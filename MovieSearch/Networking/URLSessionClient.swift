//
//  URLSessionClient.swift
//  MovieSearch
//
//  Created by Luana Duarte on 14/08/25.
//

import Foundation

final class URLSessionClient: Networking {
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        configuration.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 100 * 1024 * 1024,
            directory: nil
        )
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        return URLSession(configuration: configuration)
    }()
        
    func perform<T>(
        _ request: Request,
        completion: @escaping (Result<T, NetworkingError>) -> Void
    ) where T : Decodable {
        execute(request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let parsedData = try decoder.decode(T.self, from: data)
                    completion(.success(parsedData))
                } catch {
                    completion(.failure(.decodingFailed(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func perform(
        _ request: Request,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        execute(request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func execute(
        _ request: Request,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        if let queryParams = request.queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let urlFromComponents = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: urlFromComponents)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.timeoutInterval = 10
        
        if let cachedData = fetchFromCache(for: urlRequest) {
            completion(.success(cachedData))
            return
        }
        
        if let bodyDict = request.bodyParams {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(.invalidBodyData))
                return
            }
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error as? URLError {
                switch error.code {
                case .notConnectedToInternet:
                    completion(.failure(.noInternetConnection))
                case .timedOut:
                    completion(.failure(.timeout))
                case .cancelled:
                    completion(.failure(.cancelled))
                default:
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(code: httpResponse.statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidResponseData))
                return
            }
            
            completion(.success(data))
        }
        .resume()
    }
    
    private func fetchFromCache(for request: URLRequest) -> Data? {
        return session.configuration.urlCache?.cachedResponse(for: request)?.data
    }
}

//
//  URLSessionClient.swift
//  MovieSearch
//
//  Created by Luana Duarte on 14/08/25.
//

import Foundation


final class URLSessionClient: Networking {
    
    func perform<T>(
        _ request: Request,
        shouldIgnoreCache: Bool = false,
        completion: @escaping (Result<T, NetworkingError>) -> Void
    ) where T : Decodable {
        execute(request, shouldIgnoreCache: shouldIgnoreCache) { result in
            
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
        shouldIgnoreCache: Bool = false,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        execute(request, shouldIgnoreCache: shouldIgnoreCache) { result in
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
        shouldIgnoreCache: Bool = false,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = request.path
        if let queryParams = request.queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let urlFromComponents = components.url  else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: urlFromComponents)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.timeoutInterval = 10
        urlRequest.cachePolicy = shouldIgnoreCache ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy
        
        if let bodyDict = request.bodyParams {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(.invalidBodyData))
                return
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
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
}

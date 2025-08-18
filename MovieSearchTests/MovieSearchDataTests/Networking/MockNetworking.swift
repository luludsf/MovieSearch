//
//  MockNetworking.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

@testable import MovieSearch
import XCTest

class MockNetworking: Networking {
    var shouldSucceed = true
    var mockMovieSearchResponse: MovieSearchRespone?
    var mockMovieResponse: MovieResponse?
    var mockImageData: Data?
    var mockError: NetworkingError?
    var request: Request?
    
    func perform<T>(_ request: Request, completion: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable {
        self.request = request
        
        if shouldSucceed {
            if let mockResponse = mockMovieSearchResponse as? T {
                completion(.success(mockResponse))
            } else if let mockResponse = mockMovieResponse as? T {
                completion(.success(mockResponse))
            } else {
                completion(.failure(.invalidResponseData))
            }
        } else {
            if let error = mockError {
                completion(.failure(error))
            } else {
                completion(.failure(.requestFailed(NSError(domain: "Test", code: -1))))
            }
        }
    }
    
    func perform(_ request: Request, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        self.request = request
        
        if shouldSucceed {
            if let data = mockImageData {
                completion(.success(data))
            } else {
                completion(.success(Data()))
            }
        } else {
            if let error = mockError {
                completion(.failure(error))
            } else {
                completion(.failure(.requestFailed(NSError(domain: "Test", code: -1))))
            }
        }
    }
}

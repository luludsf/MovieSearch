//
//  NetworkingError.swift
//  MovieSearch
//
//  Created by Luana Duarte on 14/08/25.
//

enum NetworkingError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidResponseData
    case decodingFailed(Error)
    case invalidBodyData
    case noInternetConnection
    case timeout
    case cancelled
    case httpError(code: Int)
}

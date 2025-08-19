//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockMovieSearchUseCase: MovieSearchUseCaseProtocol {
    var shouldSucceed = true
    var mockMovieSearch: MovieSearch?
    var mockError: MovieSearchError?
    var lastQuery: String?
    var lastPage: Int?
    
    func execute(query: String, page: Int?, completion: @escaping (Result<MovieSearch, MovieSearchError>) -> Void) {
        self.lastQuery = query
        self.lastPage = page
        
        if shouldSucceed {
            if let mockMovieSearch = mockMovieSearch {
                completion(.success(mockMovieSearch))
            } else {
                completion(.failure(.unexpected))
            }
        } else {
            if let error = mockError {
                completion(.failure(error))
            } else {
                completion(.failure(.unexpected))
            }
        }
    }
}

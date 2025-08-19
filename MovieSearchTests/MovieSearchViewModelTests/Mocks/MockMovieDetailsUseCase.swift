//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockMovieDetailsUseCase: MovieDetailsUseCaseProtocol {
    var shouldSucceed = true
    var mockMovie: Movie?
    var mockError: MovieSearchError?
    var lastId: Int?
    
    func execute(id: Int, completion: @escaping (Result<Movie, MovieSearchError>) -> Void) {
        self.lastId = id
        
        if shouldSucceed {
            if let mockMovie = mockMovie {
                completion(.success(mockMovie))
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

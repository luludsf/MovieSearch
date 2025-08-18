//
//  MockMovieSearchRepository.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockMovieSearchRepository: MovieSearchRepositoryProtocol {
    
    var shouldSuceed = true
    var mockMovieSearch: MovieSearch?
    var mockMovie: Movie?
    var mockImageData: Data?
    var mockError: MovieSearchError?
    var query: String?
    var page: Int?
    var movieId: Int?
    var imageUrl: String?
    var imageType: ImageType?
    
    func getSearch(from query: String, page: Int?, completion: @escaping (Result<MovieSearch, MovieSearchError>) -> Void) {
        self.query = query
        self.page = page
        
        if shouldSuceed {
            if let mockSearch = mockMovieSearch {
                completion(.success(mockSearch))
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
    
    func getMovieDetails(with id: Int, completion: @escaping (Result<Movie, MovieSearchError>) -> Void) {
        self.movieId = id
        
        if shouldSuceed {
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
    
    func getMovieImage(from url: String, with imageType: ImageType, completion: @escaping (Result<Data?, MovieSearchError>) -> Void) {
        self.imageUrl = url
        self.imageType = imageType
        
        if shouldSuceed {
            completion(.success(mockImageData))
        } else {
            if let error = mockError {
                completion(.failure(error))
            } else {
                completion(.failure(.unexpected))
            }
        }
    }
}

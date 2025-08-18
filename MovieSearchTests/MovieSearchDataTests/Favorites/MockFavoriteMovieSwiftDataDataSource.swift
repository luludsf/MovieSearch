//
//  MockFavoriteMovieSwiftDataDataSource.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

class MockFavoriteMovieSwiftDataDataSource: FavoriteMovieDataSourceProtocol {
    var shouldSucceed = true
    var savedMovies: [MovieObject] = []
    var deletedMovies: [MovieObject] = []
    var favoriteMovies: [MovieObject] = []
    
    func saveFavoriteMovie(_ movie: MovieObject, completion: @escaping (Bool) -> Void) {
        if shouldSucceed {
            savedMovies.append(movie)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteFavoriteMovie(_ movie: MovieObject, completion: @escaping (Bool) -> Void) {
        if shouldSucceed {
            deletedMovies.append(movie)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void) {
        completion(shouldSucceed)
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([MovieObject]?) -> Void) {
        completion(shouldSucceed ? favoriteMovies : nil)
    }
}

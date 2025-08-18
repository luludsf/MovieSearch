//
//  MockFavoriteMoviesRepository.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockFavoriteMoviesRepository: FavoriteMoviesRepositoryProtocol {
    var shouldSucceed = true
    var savedMovies: [Movie] = []
    var deletedMovies: [Movie] = []
    var favoriteMovies: [Movie] = []
    var isMovieFavorite = false
    var movie: Movie?
    var movieId: Int?
    
    func saveFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        self.movie = movie
        if shouldSucceed {
            savedMovies.append(movie)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        self.movie = movie
        if shouldSucceed {
            deletedMovies.append(movie)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void) {
        self.movieId = id
        completion(shouldSucceed ? isMovieFavorite : false)
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void) {
        completion(shouldSucceed ? favoriteMovies : nil)
    }
}

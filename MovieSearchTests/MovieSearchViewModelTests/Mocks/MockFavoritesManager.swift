//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockFavoritesManager: FavoritesManagerProtocol {
    
    var shouldSucceed = true
    var isMovieFavorite = false
    var mockFavoriteMovies: [Movie] = []
    var lastMovie: Movie?
    var lastIsFavorite: Bool?
    var lastMovieId: Int?
    
    func saveFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        self.lastMovie = movie
        self.lastIsFavorite = true
        completion(shouldSucceed)
    }
    
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        self.lastMovie = movie
        self.lastIsFavorite = false
        completion(shouldSucceed)
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void) {
        completion(mockFavoriteMovies)
    }
    
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void) {
        self.lastMovieId = movieId
        completion(isMovieFavorite)
    }
    
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void) {
        self.lastMovie = selectedMovie
        self.lastIsFavorite = isFavorite
        completion(shouldSucceed)
    }
}

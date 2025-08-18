//
//  FavoritesManagerProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

protocol FavoritesManagerProtocol {
    func saveFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void)
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void)
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void)
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void)
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void)
}

//
//  FavoriteMoviesRepositoryProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol FavoriteMoviesRepositoryProtocol {
    func saveFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void)
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void)
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void)
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void)
}

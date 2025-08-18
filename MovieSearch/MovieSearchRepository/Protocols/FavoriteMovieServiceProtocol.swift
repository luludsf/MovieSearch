//
//  FavoriteMovieServiceProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol FavoriteMovieServiceProtocol {
    func saveFavoriteMovie(_ movie: MovieObject, completion: @escaping (Bool) -> Void)
    func deleteFavoriteMovie(_ movie: MovieObject, completion: @escaping (Bool) -> Void)
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void)
    func fetchAllFavoriteMovies(completion: @escaping ([MovieObject]?) -> Void)
}

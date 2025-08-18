//
//  FavoriteMoviesViewModelProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import Foundation

protocol FavoriteMoviesViewModelProtocol {
    var coordinatorDelegate: CoordinatorDelegate? { get set }
    
    func openMovieDetails(with movieId: Int)
    func fetchImageData(from url: String, completion: @escaping (Data?) -> Void)
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void)
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void)
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void)
}

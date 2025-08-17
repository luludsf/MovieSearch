//
//  MovieSearchRepositoryFactoryProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol MovieSearchRepositoryFactoryProtocol {
    func makeMovieSearchRepository() -> MovieSearchRepositoryProtocol
    func makeFavoriteMoviesRepository() -> FavoriteMoviesRepositoryProtocol
}

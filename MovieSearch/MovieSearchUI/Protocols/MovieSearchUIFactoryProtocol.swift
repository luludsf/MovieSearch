//
//  MovieSearchUIFactoryProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

protocol MovieSearchUIFactoryProtocol {
    func makeFavoriteMoviesViewController(delegate: CoordinatorDelegate?) -> FavoriteMoviesViewController
    func makeMovieDetailsViewController(movieId: Int) -> MovieDetailsViewController
    func makeMovieSearchViewController(delegate: CoordinatorDelegate?) -> MovieSearchViewController
    func makeMovieSearchResultViewController(textToSearch: String, delegate: CoordinatorDelegate?) -> MovieSearchResultViewController
}

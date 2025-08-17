//
//  MovieSearchResultViewModelProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import Foundation

protocol MovieSearchResultViewModelProtocol {
    var query: String { get }
    var delegate: MovieSearchResultViewModelDelegate? { get set }
    var coordinatorDelegate: CoordinatorDelegate? { get set }
    
    func fetchNextPage()
    func fetchSearchMovies(query: String, page: Int?)
    func openMovieDetails(with movieId: Int)
    func fetchImageData(from url: String, shouldIgnoreCache: Bool, completion: @escaping (Data?) -> Void)
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie)
    func isFavoriteMovie(movie: Movie, completion: @escaping (Bool) -> Void)
}

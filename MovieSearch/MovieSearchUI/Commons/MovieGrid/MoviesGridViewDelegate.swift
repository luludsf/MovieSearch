//
//  MoviesGridViewDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import Foundation

protocol MoviesGridViewDelegate: AnyObject {
    func getNextPage()
    func openMovieDetails(with movieId: Int)
    func getImageData(from url: String, completion: @escaping (Data?) -> Void)
    func getFavorite(movie: Movie, completion: @escaping (Bool) -> Void)
    func didTapFavoriteButton(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void)
}

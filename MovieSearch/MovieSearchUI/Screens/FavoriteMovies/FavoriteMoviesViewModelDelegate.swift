//
//  FavoriteMoviesViewModelDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

protocol FavoriteMoviesViewModelDelegate: AnyObject {
    func didReceiveMovies(_ movies: [Movie]?)
    func didFailWithError(_ message: String)
}

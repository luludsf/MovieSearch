//
//  MovieSearchResultViewModelDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

protocol MovieSearchResultViewModelDelegate: AnyObject {
    func didReceiveMovies(_ movies: [Movie], hasMorePages: Bool)
    func didFailWithError(_ message: String)
}

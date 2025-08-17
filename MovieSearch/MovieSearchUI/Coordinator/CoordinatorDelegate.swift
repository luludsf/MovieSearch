//
//  CoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

protocol CoordinatorDelegate: AnyObject {
    func showMovieSearchResultsViewController(with textToSearch: String)
    func showMovieDetailsViewController(with movieId: Int)
}

extension CoordinatorDelegate {
    func showMovieSearchResultsViewController(with textToSearch: String) { }
    func showMovieDetailsViewController(with movieId: Int) { }
}

//
//  MovieSearchViewModel.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

final class MovieSearchViewModel: MovieSearchViewModelProtocol {
    weak var coordinatorDelegate: CoordinatorDelegate?
    
    func openMovieResults(for query: String) {
        coordinatorDelegate?.showMovieSearchResultsViewController(with: query)
    }
}

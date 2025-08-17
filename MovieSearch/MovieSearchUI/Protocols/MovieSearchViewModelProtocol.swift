//
//  MovieSearchViewModelProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

protocol MovieSearchViewModelProtocol {
    var coordinatorDelegate: CoordinatorDelegate? { get set }
    func openMovieResults(for query: String)
}

//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import XCTest
@testable import MovieSearch

// MARK: - Mock Coordinator Delegate

class MockCoordinatorDelegate: CoordinatorDelegate {
    var showMovieSearchResultsCalled = false
    var showMovieDetailsCalled = false
    var lastQuery: String?
    var lastMovieId: Int?
    var lastUpdateDelegate: MovieSearchResultViewControllerUpdateDelegate?
    
    func showMovieSearchResultsViewController(with textToSearch: String) {
        showMovieSearchResultsCalled = true
        lastQuery = textToSearch
    }
    
    func showMovieDetailsViewController(with movieId: Int, updateDelegate: MovieSearchResultViewControllerUpdateDelegate?) {
        showMovieDetailsCalled = true
        lastMovieId = movieId
        lastUpdateDelegate = updateDelegate
    }
}

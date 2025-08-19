//
//  MockMovieSearchResultViewModelDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import XCTest
@testable import MovieSearch

// MARK: - Mock Classes

class MockMovieSearchResultViewModelDelegate: MovieSearchResultViewModelDelegate {
    var didReceiveMoviesCalled: (([Movie], Bool) -> Void)?
    var didFailWithErrorCalled: ((String) -> Void)?
    
    func didReceiveMovies(_ movies: [Movie], hasMorePages: Bool) {
        didReceiveMoviesCalled?(movies, hasMorePages)
    }
    
    func didFailWithError(_ error: String) {
        didFailWithErrorCalled?(error)
    }
}

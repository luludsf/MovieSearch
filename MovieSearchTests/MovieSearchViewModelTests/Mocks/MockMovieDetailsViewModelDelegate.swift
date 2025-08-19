//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockMovieDetailsViewModelDelegate: MovieDetailsViewModelDelegate {
    var didFetchMovieCalled: ((Movie) -> Void)?
    var didFetchImageDataCalled: ((Data?) -> Void)?
    var didFailWithErrorCalled: ((String) -> Void)?
    var didStartLoadingCalled = false
    
    func didFetch(_ movie: Movie) {
        didFetchMovieCalled?(movie)
    }
    
    func didFetch(_ imageData: Data?) {
        didFetchImageDataCalled?(imageData)
    }
    
    func didFailWithError(_ error: String) {
        didFailWithErrorCalled?(error)
    }
    
    func didStartLoading() {
        didStartLoadingCalled = true
    }
}

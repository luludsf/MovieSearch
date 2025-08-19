//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockMovieSearchResultViewControllerUpdateDelegate: MovieSearchResultViewControllerUpdateDelegate {
    var reloadViewCalled = false
    var reloadViewClosure: (() -> Void)?
    
    func reloadView() {
        reloadViewCalled = true
        reloadViewClosure?()
    }
}

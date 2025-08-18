//
//  MovieSearchRepositoryFactoryTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieSearchRepositoryFactoryTests: XCTestCase {
    
    var sut: MovieSearchRepositoryFactory!
    
    override func setUp() {
        super.setUp()
        sut = MovieSearchRepositoryFactory()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_makeMovieSearchRepository_ShouldReturnMovieSearchRepository() {
        // When
        let repository = sut.makeMovieSearchRepository()
        
        // Then
        XCTAssertTrue(repository is MovieSearchRepository)
    }
    
    func test_makeFavoriteMoviesRepository_ShouldReturnFavoriteMoviesRepository() {
        // When
        let repository = sut.makeFavoriteMoviesRepository()
        
        // Then
        XCTAssertTrue(repository is FavoriteMoviesRepository)
    }
}

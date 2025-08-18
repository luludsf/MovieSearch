//
//  FetchFavoriteMovieUseCaseTests.swift
//  MovieSearchDomainTests
//
//  Created by Luana Duarte on 15/08/25.
//

import XCTest
@testable import MovieSearch

final class FetchFavoriteMovieUseCaseTests: XCTestCase {
    
    var sut: FetchFavoriteMovieUseCase!
    var mockRepository: MockFavoriteMoviesRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockFavoriteMoviesRepository()
        sut = FetchFavoriteMovieUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_execute_WhenMovieIsFavorite_ShouldReturnTrue() {
        // Given
        let expectation = XCTestExpectation(description: "Favorito recuperado com sucesso")
        
        mockRepository.isMovieFavorite = true
        mockRepository.shouldSucceed = true
        
        // When
        sut.execute(123) { isFavorite in
            // Then
            XCTAssertTrue(isFavorite)
            XCTAssertEqual(self.mockRepository.movieId, 123)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_WhenMovieIsNotFavorite_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme informado não é favorito")
        mockRepository.isMovieFavorite = false
        mockRepository.shouldSucceed = false
        
        // When
        sut.execute(123) { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            XCTAssertEqual(self.mockRepository.movieId, 123)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

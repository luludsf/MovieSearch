//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieSearchViewModelTests: XCTestCase {
    
    var sut: MovieSearchViewModel!
    var mockCoordinatorDelegate: MockCoordinatorDelegate!
    
    override func setUp() {
        super.setUp()
        mockCoordinatorDelegate = MockCoordinatorDelegate()
        sut = MovieSearchViewModel()
        sut.coordinatorDelegate = mockCoordinatorDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockCoordinatorDelegate = nil
        super.tearDown()
    }
    
    // MARK: - openMovieResults Tests
    
    func test_openMovieResults_WithValidQuery_ShouldCallCoordinator() {
        // Given
        let query = "Barbie"
        
        // When
        sut.openMovieResults(for: query)
        
        // Then
        XCTAssertEqual(mockCoordinatorDelegate.lastQuery, query)
        XCTAssertTrue(mockCoordinatorDelegate.showMovieSearchResultsCalled)
    }
    
    func test_openMovieResults_WithSpecialCharacters_ShouldCallCoordinator() {
        // Given
        let query = "Barbie & The Sensations"
        
        // When
        sut.openMovieResults(for: query)
        
        // Then
        XCTAssertEqual(mockCoordinatorDelegate.lastQuery, "Barbie & The Sensations")
        XCTAssertTrue(mockCoordinatorDelegate.showMovieSearchResultsCalled)
    }
    
    func test_openMovieResults_WithLongQuery_ShouldCallCoordinator() {
        // Given
        let query = "Um item muito grande a ser pesquisado nesse app de filmes"
        
        // When
        sut.openMovieResults(for: query)
        
        // Then
        XCTAssertEqual(mockCoordinatorDelegate.lastQuery, query)
        XCTAssertTrue(mockCoordinatorDelegate.showMovieSearchResultsCalled)
    }
    
    // MARK: - Title Tests
    
    func test_title_ShouldReturnCorrectValue() {
        // Then
        XCTAssertEqual(sut.title, UIStrings.Search.title)
    }
}

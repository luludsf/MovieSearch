//
//  FavoriteMoviesRepositoryTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class FavoriteMoviesRepositoryTests: XCTestCase {
    
    var sut: FavoriteMoviesRepository!
    var mockService: MockFavoriteMovieService!
    
    override func setUp() {
        super.setUp()
        mockService = MockFavoriteMovieService()
        sut = FavoriteMoviesRepository(service: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - saveFavoriteMovie Tests
    
    func test_saveFavoriteMovie_WhenSuccessful_ShouldCallServiceAndReturnTrue() {
        // Given
        let expectation = XCTestExpectation(description: "Favorito salvo")
        let movie = Movie(
            id: 1,
            originalTitle: "Test Movie",
            posterPath: "/test.jpg",
            voteAverage: 8.5,
            backdropPath: "/backdrop.jpg",
            title: "Test Movie",
            overview: "Test overview",
            releaseDate: "2023-01-01",
            budget: 1000000,
            revenue: 5000000
        )
        mockService.shouldSucceed = true
        
        // When
        sut.saveFavoriteMovie(movie) { success in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockService.savedMovies.count, 1)
            XCTAssertEqual(self.mockService.savedMovies.first?.id, 1)
            XCTAssertEqual(self.mockService.savedMovies.first?.title, "Test Movie")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_saveFavoriteMovie_WhenServiceFails_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme não salvo")
        let movie = Movie(
            id: 1,
            originalTitle: "Test Movie",
            posterPath: "/test.jpg",
            voteAverage: 8.5,
            backdropPath: "/backdrop.jpg",
            title: "Test Movie",
            overview: "Test overview",
            releaseDate: "2023-01-01",
            budget: 1000000,
            revenue: 5000000
        )
        mockService.shouldSucceed = false
        
        // When
        sut.saveFavoriteMovie(movie) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - deleteFavoriteMovie Tests
    
    func test_deleteFavoriteMovie_WhenSuccessful_ShouldCallServiceAndReturnTrue() {
        // Given
        let expectation = XCTestExpectation(description: "Filme deletado")
        let movie = Movie(
            id: 1,
            originalTitle: "Test Movie",
            posterPath: "/test.jpg",
            voteAverage: 8.5,
            backdropPath: "/backdrop.jpg",
            title: "Test Movie",
            overview: "Test overview",
            releaseDate: "2023-01-01",
            budget: 1000000,
            revenue: 5000000
        )
        mockService.shouldSucceed = true
        
        // When
        sut.deleteFavoriteMovie(movie) { success in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockService.deletedMovies.count, 1)
            XCTAssertEqual(self.mockService.deletedMovies.first?.id, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_deleteFavoriteMovie_WhenServiceFails_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme nõa deletado")
        let movie = Movie(
            id: 1,
            originalTitle: "Test Movie",
            posterPath: "/test.jpg",
            voteAverage: 8.5,
            backdropPath: "/backdrop.jpg",
            title: "Test Movie",
            overview: "Test overview",
            releaseDate: "2023-01-01",
            budget: 1000000,
            revenue: 5000000
        )
        mockService.shouldSucceed = false
        
        // When
        sut.deleteFavoriteMovie(movie) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchAllFavoriteMovies Tests
    
    func test_fetchAllFavoriteMovies_WhenSuccessful_ShouldReturnMovies() {
        // Given
        let expectation = XCTestExpectation(description: "Filmes encontrados")
        let mockMovieObjects = [
            MovieObject(
                id: 1,
                originalTitle: "Movie 1",
                posterPath: "/poster1.jpg",
                voteAverage: 8.0,
                backdropPath: "/backdrop1.jpg",
                title: "Movie 1",
                overview: "Overview 1",
                releaseDate: "2023-01-01",
                budget: 1000000,
                revenue: 5000000
            ),
            MovieObject(
                id: 2,
                originalTitle: "Movie 2",
                posterPath: "/poster2.jpg",
                voteAverage: 7.5,
                backdropPath: "/backdrop2.jpg",
                title: "Movie 2",
                overview: "Overview 2",
                releaseDate: "2023-02-01",
                budget: 2000000,
                revenue: 8000000
            )
        ]
        mockService.favoriteMovies = mockMovieObjects
        mockService.shouldSucceed = true
        
        // When
        sut.fetchAllFavoriteMovies { movies in
            // Then
            XCTAssertNotNil(movies)
            XCTAssertEqual(movies?.count, 2)
            XCTAssertEqual(movies?.first?.id, 1)
            XCTAssertEqual(movies?.first?.title, "Movie 1")
            XCTAssertEqual(movies?.last?.id, 2)
            XCTAssertEqual(movies?.last?.title, "Movie 2")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchAllFavoriteMovies_WhenServiceFails_ShouldReturnNil() {
        // Given
        let expectation = XCTestExpectation(description: "Filmes favoritos não encontrados")
        mockService.shouldSucceed = false
        
        // When
        sut.fetchAllFavoriteMovies { movies in
            // Then
            XCTAssertNil(movies)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchFavoriteMovie Tests
    
    func test_fetchFavoriteMovie_WhenSuccessful_ShouldReturnTrue() {
        // Given
        let expectation = XCTestExpectation(description: "Filme favorito encontrado")
        mockService.shouldSucceed = true
        
        // When
        sut.fetchFavoriteMovie(id: 1) { isFavorite in
            // Then
            XCTAssertTrue(isFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchFavoriteMovie_WhenServiceFails_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme favorito não encontrado")
        mockService.shouldSucceed = false
        
        // When
        sut.fetchFavoriteMovie(id: 1) { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

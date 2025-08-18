//
//  FavoriteMovieServiceTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch
import SwiftData

final class FavoriteMovieServiceTests: XCTestCase {
    
    var sut: FavoriteMovieService!
    var modelContainer: ModelContainer!
    
    override func setUp() {
        super.setUp()
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            modelContainer = try ModelContainer(for: MovieObject.self, configurations: config)
            sut = FavoriteMovieService(modelContainer: modelContainer)
        } catch {
            XCTFail("Criação do ModelContainer falhou: \(error)")
        }
    }
    
    override func tearDown() {
        sut = nil
        modelContainer = nil
        super.tearDown()
    }
    
    // MARK: - saveFavoriteMovie Tests
    
    func test_saveFavoriteMovie_WhenSuccessful_ShouldSaveToDatabase() {
        // Given
        let expectation = XCTestExpectation(description: "Filme salvo com sucesso")
        let movie = MovieObject(
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
        
        // When
        sut.saveFavoriteMovie(movie) { success in
            // Then
            XCTAssertTrue(success)
            
            // Verify movie was saved
            let descriptor = FetchDescriptor<MovieObject>()
            DispatchQueue.main.async {
                let savedMovies = try? self.modelContainer.mainContext.fetch(descriptor)
                XCTAssertEqual(savedMovies?.count, 1)
                XCTAssertEqual(savedMovies?.first?.id, 1)
                XCTAssertEqual(savedMovies?.first?.title, "Test Movie")
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_saveFavoriteMovie_WhenModelContainerIsNil_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme não salvo")
        let service = FavoriteMovieService(modelContainer: nil)
        let movie = MovieObject(
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
        
        // When
        service.saveFavoriteMovie(movie) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - deleteFavoriteMovie Tests
    
    func test_deleteFavoriteMovie_WhenSuccessful_ShouldDeleteFromDatabase() {
        // Given
        let expectation = XCTestExpectation(description: "Filme deletado com sucesso")
        let movie = MovieObject(
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
        
        DispatchQueue.main.async {
            // When
            self.modelContainer.mainContext.insert(movie)
            try? self.modelContainer.mainContext.save()
            
            var descriptor = FetchDescriptor<MovieObject>()
            var savedMovies = try? self.modelContainer.mainContext.fetch(descriptor)
            
            // Then
            XCTAssertEqual(savedMovies?.count, 1)
            
            
            self.sut.deleteFavoriteMovie(movie) { success in
                // Then
                XCTAssertTrue(success)
                
                descriptor = FetchDescriptor<MovieObject>()
                savedMovies = try? self.modelContainer.mainContext.fetch(descriptor)
                XCTAssertEqual(savedMovies?.count, 0)
                
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchFavoriteMovie Tests
    
    func test_fetchFavoriteMovie_WhenMovieExists_ShouldReturnTrue() {
        // Given
        let expectation = XCTestExpectation(description: "Favorito encontrado")
        let movie = MovieObject(
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
        
        // When
        
        DispatchQueue.main.async {
            self.modelContainer.mainContext.insert(movie)
            try? self.modelContainer.mainContext.save()
            
            self.sut.fetchFavoriteMovie(id: 1) { isFavorite in
                // Then
                XCTAssertTrue(isFavorite)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchFavoriteMovie_WhenMovieDoesNotExist_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Favorito não existe")
        
        // When
        sut.fetchFavoriteMovie(id: 999) { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchAllFavoriteMovies Tests
    
    func test_fetchAllFavoriteMovies_WhenSuccessful_ShouldReturnAllMovies() {
        // Given
        let expectation = XCTestExpectation(description: "Favoritos encontrados")
        let movies = [
            MovieObject(
                id: 1,
                originalTitle: "Movie A",
                posterPath: "/poster1.jpg",
                voteAverage: 8.0,
                backdropPath: "/backdrop1.jpg",
                title: "Movie A",
                overview: "Overview A",
                releaseDate: "2023-01-01",
                budget: 1000000,
                revenue: 5000000
            ),
            MovieObject(
                id: 2,
                originalTitle: "Movie B",
                posterPath: "/poster2.jpg",
                voteAverage: 7.5,
                backdropPath: "/backdrop2.jpg",
                title: "Movie B",
                overview: "Overview B",
                releaseDate: "2023-02-01",
                budget: 2000000,
                revenue: 8000000
            )
        ]
        
        DispatchQueue.main.async {
            
            // When
            for movie in movies {
                self.modelContainer.mainContext.insert(movie)
            }
            try? self.modelContainer.mainContext.save()
            
            self.sut.fetchAllFavoriteMovies { fetchedMovies in
                // Then
                XCTAssertNotNil(fetchedMovies)
                XCTAssertEqual(fetchedMovies?.count, 2)
                XCTAssertEqual(fetchedMovies?.first?.originalTitle, "Movie A")
                XCTAssertEqual(fetchedMovies?.last?.originalTitle, "Movie B")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchAllFavoriteMovies_WhenNoMovies_ShouldReturnEmptyArray() {
        // Given
        let expectation = XCTestExpectation(description: "Nenhum favorito encontrado")
        
        // When
        sut.fetchAllFavoriteMovies { fetchedMovies in
            // Then
            XCTAssertNotNil(fetchedMovies)
            XCTAssertEqual(fetchedMovies?.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

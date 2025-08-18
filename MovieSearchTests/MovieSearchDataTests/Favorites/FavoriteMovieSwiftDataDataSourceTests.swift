//
//  FavoriteMovieSwiftDataDataSourceTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch
import SwiftData

final class FavoriteMovieSwiftDataDataSourceTests: XCTestCase {
    
    var sut: FavoriteMovieSwiftDataDataSource!
    var modelContainer: ModelContainer!
    
    override func setUp() {
        super.setUp()
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            modelContainer = try ModelContainer(for: MovieObject.self, configurations: config)
            sut = FavoriteMovieSwiftDataDataSource(modelContainer: modelContainer)
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
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
            releaseDate: "1987-09-27",
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
                XCTAssertEqual(savedMovies?.first?.id, 198884)
                XCTAssertEqual(savedMovies?.first?.title, "Barbie and the Sensations: Rockin' Back to Earth")
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_saveFavoriteMovie_WhenModelContainerIsNil_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme não salvo")
        let service = FavoriteMovieSwiftDataDataSource(modelContainer: nil)
        let movie = MovieObject(
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
            releaseDate: "1987-09-27",
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
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
            releaseDate: "1987-09-27",
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
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
            releaseDate: "1987-09-27",
            budget: 1000000,
            revenue: 5000000
        )
        
        // When
        
        DispatchQueue.main.async {
            self.modelContainer.mainContext.insert(movie)
            try? self.modelContainer.mainContext.save()
            
            self.sut.fetchFavoriteMovie(id: 198884) { isFavorite in
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
                id: 198884,
                originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
                posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
                voteAverage: 7.5,
                backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
                title: "Barbie and the Sensations: Rockin' Back to Earth",
                overview: "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
                releaseDate: "1987-09-27",
                budget: 1000000,
                revenue: 5000000
            ),
            MovieObject(
                id: 973042,
                originalTitle: "Max Steel: Turbo Charged",
                posterPath: "/566jQXMLiYm1G2JEMOCiaSFM3Ad.jpg",
                voteAverage: 0,
                backdropPath: "/2cFk2AHymCALBaBfi8R2JWNmt1W.jpg",
                title: "Max Steel: Turbo Charged",
                overview: "Max must master an all-new, more powerful form of turbo energy if he wants to defeat Terrorax.",
                releaseDate: "2017-03-18",
                budget: 2000000,
                revenue: 1000000
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
                XCTAssertEqual(fetchedMovies?.first?.originalTitle, "Barbie and The Sensations: Rockin' Back to Earth")
                XCTAssertEqual(fetchedMovies?.last?.originalTitle, "Max Steel: Turbo Charged")
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

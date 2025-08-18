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
        mockService.shouldSucceed = true
        
        // When
        sut.saveFavoriteMovie(movie) { success in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockService.savedMovies.count, 1)
            XCTAssertEqual(self.mockService.savedMovies.first?.id, 198884)
            XCTAssertEqual(self.mockService.savedMovies.first?.title, "Barbie and the Sensations: Rockin' Back to Earth")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_saveFavoriteMovie_WhenServiceFails_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme não salvo")
        let movie = Movie(
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
        mockService.shouldSucceed = true
        
        // When
        sut.deleteFavoriteMovie(movie) { success in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockService.deletedMovies.count, 1)
            XCTAssertEqual(self.mockService.deletedMovies.first?.id, 198884)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_deleteFavoriteMovie_WhenServiceFails_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Filme nõa deletado")
        let movie = Movie(
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
        mockService.favoriteMovies = mockMovieObjects
        mockService.shouldSucceed = true
        
        // When
        sut.fetchAllFavoriteMovies { movies in
            // Then
            XCTAssertNotNil(movies)
            XCTAssertEqual(movies?.count, 2)
            XCTAssertEqual(movies?.first?.id, 198884)
            XCTAssertEqual(movies?.first?.title, "Barbie and the Sensations: Rockin' Back to Earth")
            XCTAssertEqual(movies?.last?.id, 973042)
            XCTAssertEqual(movies?.last?.title, "Max Steel: Turbo Charged")
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
        sut.fetchFavoriteMovie(id: 198884) { isFavorite in
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
        sut.fetchFavoriteMovie(id: 198884) { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

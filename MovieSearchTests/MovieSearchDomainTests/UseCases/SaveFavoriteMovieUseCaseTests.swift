//
//  SaveFavoriteMovieUseCaseTests.swift
//  MovieSearchDomainTests
//
//  Created by Luana Duarte on 15/08/25.
//

import XCTest
@testable import MovieSearch

final class SaveFavoriteMovieUseCaseTests: XCTestCase {
    
    var sut: SaveFavoriteMovieUseCase!
    var mockRepository: MockFavoriteMoviesRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockFavoriteMoviesRepository()
        sut = SaveFavoriteMovieUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_execute_WhenSuccessful_ShouldReturnTrue() {
        // Given
        let expectation = XCTestExpectation(description: "Favorito salvo com sucesso")
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
        mockRepository.shouldSucceed = true
        
        // When
        sut.execute(movie) { success in
            // Then
            XCTAssertTrue(success)
            XCTAssertEqual(self.mockRepository.savedMovies.count, 1)
            XCTAssertEqual(self.mockRepository.savedMovies.first?.id, 198884)
            XCTAssertEqual(self.mockRepository.savedMovies.first?.title, "Barbie and the Sensations: Rockin' Back to Earth")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_WhenFail_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Favorito não foi salvo")
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
        mockRepository.shouldSucceed = false
        
        // When
        sut.execute(movie) { success in
            // Then
            XCTAssertFalse(success)
            XCTAssertEqual(self.mockRepository.savedMovies.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

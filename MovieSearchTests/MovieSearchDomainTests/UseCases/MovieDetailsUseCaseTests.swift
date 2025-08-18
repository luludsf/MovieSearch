//
//  MovieDetailsUseCaseTests.swift
//  MovieSearchDomainTests
//
//  Created by Luana Duarte on 15/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieDetailsUseCaseTests: XCTestCase {
    
    var sut: MovieDetailsUseCase!
    var mockRepository: MockMovieSearchRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieSearchRepository()
        sut = MovieDetailsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_execute_WhenSuccessful_ShouldReturnMovie() {
        // Given
        let expectation = XCTestExpectation(description: "Detalhes do filme recuperado com sucesso")
        let mockMovie = Movie(
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
        mockRepository.mockMovie = mockMovie
        mockRepository.shouldSuceed = true
        
        // When
        sut.execute(id: 198884) { result in
            // Then
            switch result {
            case .success(let movie):
                XCTAssertEqual(movie.id, 198884)
                XCTAssertEqual(movie.originalTitle, "Barbie and The Sensations: Rockin' Back to Earth")
                XCTAssertEqual(movie.title, "Barbie and the Sensations: Rockin' Back to Earth")
                XCTAssertEqual(movie.voteAverage, 7.5)
                XCTAssertEqual(movie.budget, 1000000)
                XCTAssertEqual(movie.revenue, 5000000)
            case .failure:
                XCTFail("getMovieDetailsUseCase não deveria falhar")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_execute_WhenFail_ShouldError() {
        // Given
        let expectation = XCTestExpectation(description: "Detalhes do filme não recuperado")
    
        mockRepository.shouldSuceed = false
        mockRepository.mockError = .serviceUnavailable
        
        // When
        sut.execute(id: 198884) { result in
            // Then
            switch result {
            case .success(let movie):
                XCTFail("getMovieDetailsUseCase não deveria ser sucesso")
            case .failure(let error):
                XCTAssertEqual(error, .serviceUnavailable)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

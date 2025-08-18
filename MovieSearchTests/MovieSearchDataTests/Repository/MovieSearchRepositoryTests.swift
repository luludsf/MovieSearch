//
//  MovieSearchRepositoryTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieSearchRepositoryTests: XCTestCase {
    
    var sut: MovieSearchRepository!
    var mockNetworking: MockNetworking!
    
    override func setUp() {
        super.setUp()
        mockNetworking = MockNetworking()
        sut = MovieSearchRepository(networking: mockNetworking)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworking = nil
        super.tearDown()
    }
    
    // MARK: - getSearch Tests
    
    func test_getSearch_WhenSuccessful_ShouldReturnMovieSearch() {
        // Given
        let expectation = XCTestExpectation(description: "Suceso na Busca de filmes")
        let mockResponse = MovieSearchRespone(
            results: [
                MovieResponse(
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
            ],
            page: 1,
            totalPages: 1,
            totalResults: 1
        )
        mockNetworking.mockMovieSearchResponse = mockResponse
        mockNetworking.shouldSucceed = true
        
        // When
        sut.getSearch(from: "test", page: 1) { result in
            // Then
            switch result {
            case .success(let movieSearch):
                XCTAssertEqual(movieSearch.results?.count, 1)
                XCTAssertEqual(movieSearch.results?.first?.id, 198884)
                XCTAssertEqual(movieSearch.results?.first?.title, "Barbie and the Sensations: Rockin' Back to Earth")
                XCTAssertEqual(movieSearch.page, 1)
                XCTAssertEqual(movieSearch.totalPages, 1)
                XCTAssertEqual(movieSearch.totalResults, 1)
            case .failure:
                XCTFail("Falha no teste getSearch")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getSearch_WhenNetworkingFails_ShouldReturnError() {
        // Given
        let expectation = XCTestExpectation(description: "getSearch falha networking ")
        mockNetworking.shouldSucceed = false
        mockNetworking.mockError = .httpError(code: 500)
        
        // When
        sut.getSearch(from: "test", page: 1) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Sucesso não esperado")
            case .failure(let error):
                XCTAssertEqual(error, .serviceUnavailable)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getSearch_WhenEmptyResults_ShouldReturnEmptyMovieSearch() {
        // Given
        let expectation = XCTestExpectation(description: "getSearch empty")
        let mockResponse = MovieSearchRespone(
            results: [],
            page: 1,
            totalPages: 0,
            totalResults: 0
        )
        mockNetworking.mockMovieSearchResponse = mockResponse
        mockNetworking.shouldSucceed = true
        
        // When
        sut.getSearch(from: "test", page: nil) { result in
            // Then
            switch result {
            case .success(let movieSearch):
                XCTAssertTrue(movieSearch.results?.isEmpty ?? true)
                XCTAssertEqual(movieSearch.page, 1)
                XCTAssertEqual(movieSearch.totalPages, 0)
                XCTAssertEqual(movieSearch.totalResults, 0)
            case .failure:
                XCTFail("getSearch não deveria falhar")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getSearch_WhenNilResults_ShouldReturnEmptyMovieSearch() {
        // Given
        let expectation = XCTestExpectation(description: "getSearch nil")
        let mockResponse = MovieSearchRespone(
            results: nil,
            page: 1,
            totalPages: 0,
            totalResults: 0
        )
        mockNetworking.mockMovieSearchResponse = mockResponse
        mockNetworking.shouldSucceed = true
        
        // When
        sut.getSearch(from: "test", page: 2) { result in
            // Then
            switch result {
            case .success(let movieSearch):
                XCTAssertNil(movieSearch.results)
                XCTAssertEqual(movieSearch.page, 1)
            case .failure:
                XCTFail("getSearch não deveria falhar")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - getMovieDetails Tests
    
    func test_getMovieDetails_WhenSuccessful_ShouldReturnMovie() {
        // Given
        let expectation = XCTestExpectation(description: "Succeso ao capturar MovieDetails")
        let mockResponse = MovieResponse(
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
        mockNetworking.mockMovieResponse = mockResponse
        mockNetworking.shouldSucceed = true
        
        // When
        sut.getMovieDetails(with: 198884) { result in
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
                XCTFail("getMovies não deveria falhar")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getMovieDetails_WhenNetworkingFails_ShouldReturnError() {
        // Given
        let expectation = XCTestExpectation(description: "Falha ao capturar MovieDetails")
        mockNetworking.shouldSucceed = false
        mockNetworking.mockError = .noInternetConnection
        
        // When
        sut.getMovieDetails(with: 198884) { result in
            // Then
            switch result {
            case .success:
                XCTFail("getMovies não deveria ser sucesso")
            case .failure(let error):
                XCTAssertEqual(error, .serviceUnavailable)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - getMovieImage Tests
    
    func test_getMovieImage_WhenSuccessful_ShouldReturnImageData() {
        // Given
        let expectation = XCTestExpectation(description: "Donwload da foto foi sucesso")
        let mockData = "test image data".data(using: .utf8)!
        mockNetworking.mockImageData = mockData
        mockNetworking.shouldSucceed = true
        
        // When
        sut.getMovieImage(from: "/test.jpg", with: .poster) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail("getMovieImage não deveria falhar")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getMovieImage_WhenNetworkingFails_ShouldReturnError() {
        // Given
        let expectation = XCTestExpectation(description: "Donwload da foto foi erro")
        mockNetworking.shouldSucceed = false
        mockNetworking.mockError = .timeout
        
        // When
        sut.getMovieImage(from: "/test.jpg", with: .backdrop) { result in
            // Then
            switch result {
            case .success:
                XCTFail("getMovieImage não deveria ser sucesso")
            case .failure(let error):
                XCTAssertEqual(error, .serviceUnavailable)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieSearchResultViewModelTests: XCTestCase {
    
    var sut: MovieSearchResultViewModel!
    var mockCoordinatorDelegate: MockCoordinatorDelegate!
    var mockDelegate: MockMovieSearchResultViewModelDelegate!
    var mockFavoritesManager: MockFavoritesManager!
    var mockMovieSearchUseCase: MockMovieSearchUseCase!
    var mockMovieImageDownloadUseCase: MockMovieImageDownloadUseCase!
    
    override func setUp() {
        super.setUp()
        mockCoordinatorDelegate = MockCoordinatorDelegate()
        mockDelegate = MockMovieSearchResultViewModelDelegate()
        mockFavoritesManager = MockFavoritesManager()
        mockMovieSearchUseCase = MockMovieSearchUseCase()
        mockMovieImageDownloadUseCase = MockMovieImageDownloadUseCase()
        
        sut = MovieSearchResultViewModel(
            favoritesManager: mockFavoritesManager,
            movieSearchUseCase: mockMovieSearchUseCase,
            movieImageDownloadUseCase: mockMovieImageDownloadUseCase,
            query: "Test Query"
        )
        
        sut.coordinatorDelegate = mockCoordinatorDelegate
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockCoordinatorDelegate = nil
        mockDelegate = nil
        mockFavoritesManager = nil
        mockMovieSearchUseCase = nil
        mockMovieImageDownloadUseCase = nil
        super.tearDown()
    }
    
    // MARK: - fetchSearchMovies Tests
    
    func test_fetchSearchMovies_WithValidQuery_ShouldCallUseCase() {
        // Given
        let query = "Barbie"
        let page = 1
        mockMovieSearchUseCase.shouldSucceed = true
        mockMovieSearchUseCase.mockMovieSearch = createMockMovieSearch()
        
        // When
        sut.fetchSearchMovies(query: query, page: page)
        
        // Then
        XCTAssertEqual(mockMovieSearchUseCase.lastQuery, query)
        XCTAssertEqual(mockMovieSearchUseCase.lastPage, page)
    }
    
    func test_fetchSearchMovies_WithEmptyQuery_ShouldNotCallUseCase() {
        // Given
        let query = ""
        
        // When
        sut.fetchSearchMovies(query: query, page: 1)
        
        // Then
        XCTAssertNil(mockMovieSearchUseCase.lastQuery)
        XCTAssertNil(mockMovieSearchUseCase.lastPage)
    }
    
    func test_fetchSearchMovies_WhenFailure_ShouldNotifyDelegate() {
        // Given
        let expectation = XCTestExpectation(description: "Falha na busca")
        mockMovieSearchUseCase.shouldSucceed = false
        mockMovieSearchUseCase.mockError = .serviceUnavailable
        
        mockDelegate.didFailWithErrorCalled = { error in
            XCTAssertEqual(error, MovieSearchError.serviceUnavailable.errorDescription)
            expectation.fulfill()
        }
        
        // When
        sut.fetchSearchMovies(query: "Test", page: 1)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchNextPage Tests
    
    func test_fetchNextPage_WhenHasMorePages_ShouldFetchNextPage() {
        // Given
        let mockMovieSearch = createMockMovieSearch(page: 1, totalPages: 3)
        mockMovieSearchUseCase.shouldSucceed = true
        mockMovieSearchUseCase.mockMovieSearch = mockMovieSearch
        
        // When
        sut.fetchSearchMovies(query: "Test", page: 1)
    
        // When
        sut.fetchNextPage()
        
        // Then
        XCTAssertEqual(mockMovieSearchUseCase.lastPage, 2)
    }
    
    func test_fetchNextPage_WhenNoMorePages_ShouldNotFetch() {
        // Given
        let expectation = XCTestExpectation(description: "fetchNextPage última página")
        let mockMovieSearch = createMockMovieSearch(page: 3, totalPages: 3)
        mockMovieSearchUseCase.shouldSucceed = true
        mockMovieSearchUseCase.mockMovieSearch = mockMovieSearch
        
        // When
        sut.fetchSearchMovies(query: "Test", page: 3)
        
        // When
        sut.fetchNextPage()
        sut.fetchNextPage()
        
        mockDelegate.didReceiveMoviesCalled = { [weak self] (movies: [Movie], hasMorePages: Bool) in
            // Then
            XCTAssertEqual(movies.first?.id, 198884)
            XCTAssertEqual(movies.first?.voteAverage, 7.5)
            XCTAssertEqual(self?.mockMovieSearchUseCase.lastPage, 3)
            expectation.fulfill()
        }
    }
    
    // MARK: - fetchImageData Tests
    
    func test_fetchImageData_WithValidURL_ShouldCallUseCase() {
        // Given
        let url = "/test.jpg"
        let mockData = "test data".data(using: .utf8)!
        mockMovieImageDownloadUseCase.shouldSucceed = true
        mockMovieImageDownloadUseCase.mockImageData = mockData
        
        let expectation = XCTestExpectation(description: "Successo no download da imagem")
        
        // When
        sut.fetchImageData(from: url) { imageData in
            // Then
            XCTAssertEqual(imageData, mockData)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastURL, url)
    }
    
    func test_fetchImageData_WhenFailure_ShouldReturnNil() {
        // Given
        let url = "/test.jpg"
        mockMovieImageDownloadUseCase.shouldSucceed = false
        
        let expectation = XCTestExpectation(description: "Donwload da imagem falhou")
        
        // When
        sut.fetchImageData(from: url) { imageData in
            // Then
            XCTAssertNil(imageData)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - openMovieDetails Tests
    
    func test_openMovieDetails_ShouldCallCoordinator() {
        // Given
        let movieId = 123
        let mockUpdateDelegate = MockMovieSearchResultViewControllerUpdateDelegate()
        
        // When
        sut.openMovieDetails(with: movieId, updateDelegate: mockUpdateDelegate)
        
        // Then
        XCTAssertEqual(mockCoordinatorDelegate.lastMovieId, movieId)
        XCTAssertTrue(mockCoordinatorDelegate.showMovieDetailsCalled)
    }
    
    // MARK: - manageFavoriteMovie Tests
    
    func test_manageFavoriteMovie_ShouldCallFavoritesManager() {
        // Given
        let movie = createTestMovie()
        let isFavorite = true
        let expectation = XCTestExpectation(description: "Conclusão do favorito")
        
        mockFavoritesManager.shouldSucceed = true
        
        // When
        sut.manageFavoriteMovie(isFavorite: isFavorite, selectedMovie: movie) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovie?.id, movie.id)
        XCTAssertEqual(mockFavoritesManager.lastIsFavorite, isFavorite)
    }
    
    // MARK: - isFavoriteMovie Tests
    
    func test_isFavoriteMovie_ShouldCallFavoritesManager() {
        // Given
        let movie = createTestMovie()
        let expectation = XCTestExpectation(description: "Conclusão da verificação de favorito")
        
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.isMovieFavorite = true
        
        // When
        sut.isFavoriteMovie(movie: movie) { isFavorite in
            // Then
            XCTAssertTrue(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, movie.id)
    }
    
    // MARK: - Helper Methods
    
    private func createMockMovieSearch(page: Int = 1, totalPages: Int = 5) -> MovieSearch {
        return MovieSearch(
            results: [
                createTestMovie()
            ],
            page: page,
            totalPages: totalPages,
            totalResults: 100
        )
    }
    
    private func createTestMovie() -> Movie {
        return Movie(
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Test overview",
            releaseDate: "1987-09-27",
            budget: 1000000,
            revenue: 5000000
        )
    }
}



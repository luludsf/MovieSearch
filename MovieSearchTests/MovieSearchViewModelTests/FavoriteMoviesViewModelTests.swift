//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import XCTest
@testable import MovieSearch

final class FavoriteMoviesViewModelTests: XCTestCase {
    
    var sut: FavoriteMoviesViewModel!
    var mockCoordinatorDelegate: MockCoordinatorDelegate!
    var mockFavoritesManager: MockFavoritesManager!
    var mockMovieImageDownloadUseCase: MockMovieImageDownloadUseCase!
    
    override func setUp() {
        super.setUp()
        mockCoordinatorDelegate = MockCoordinatorDelegate()
        mockFavoritesManager = MockFavoritesManager()
        mockMovieImageDownloadUseCase = MockMovieImageDownloadUseCase()
        
        sut = FavoriteMoviesViewModel(
            favoritesManager: mockFavoritesManager,
            movieImageDownloadUseCase: mockMovieImageDownloadUseCase
        )
        
        sut.coordinatorDelegate = mockCoordinatorDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockCoordinatorDelegate = nil
        mockFavoritesManager = nil
        mockMovieImageDownloadUseCase = nil
        super.tearDown()
    }
    
    // MARK: - deleteFavoriteMovie Tests
    
    func test_deleteFavoriteMovie_WhenSuccessful_ShouldReturnTrue() {
        // Given
        let movie = createTestMovie()
        let expectation = XCTestExpectation(description: "Successo da exclusão")
        mockFavoritesManager.shouldSucceed = true
        
        // When
        sut.deleteFavoriteMovie(movie) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovie?.id, movie.id)
    }
    
    func test_deleteFavoriteMovie_WhenFailure_ShouldReturnFalse() {
        // Given
        let movie = createTestMovie()
        let expectation = XCTestExpectation(description: "Falha da exclusão")
        mockFavoritesManager.shouldSucceed = false
        
        // When
        sut.deleteFavoriteMovie(movie) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovie?.id, movie.id)
    }
    
    // MARK: - fetchAllFavoriteMovies Tests
    
    func test_fetchAllFavoriteMovies_WhenSuccessful_ShouldReturnMovies() {
        // Given
        let expectation = XCTestExpectation(description: "Conclusão da busca de todos os filmes")
        let mockMovies = [createTestMovie(), createSecondTestMovie()]
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.mockFavoriteMovies = mockMovies
        
        // When
        sut.fetchAllFavoriteMovies { movies in
            // Then
            XCTAssertNotNil(movies)
            XCTAssertEqual(movies?.count, 2)
            XCTAssertEqual(movies?.first?.id, 198884)
            XCTAssertEqual(movies?.last?.id, 973042)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchAllFavoriteMovies_WhenFailure_ShouldReturnNil() {
        // Given
        let expectation = XCTestExpectation(description: "Falha na busca de todos os filmes")
        mockFavoritesManager.shouldSucceed = false
        
        // When
        sut.fetchAllFavoriteMovies { movies in
            // Then
            XCTAssertEqual(movies?.count, 0)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchAllFavoriteMovies_WhenEmpty_ShouldReturnEmptyArray() {
        // Given
        let expectation = XCTestExpectation(description: "Busca de todos os favoritos vazia")
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.mockFavoriteMovies = []
        
        // When
        sut.fetchAllFavoriteMovies { movies in
            // Then
            XCTAssertNotNil(movies)
            XCTAssertEqual(movies?.count, 0)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchFavoriteMovie Tests
    
    func test_fetchFavoriteMovie_WhenMovieIsFavorite_ShouldReturnTrue() {
        // Given
        let movieId = 198884
        let expectation = XCTestExpectation(description: "Verificação de favorito")
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.isMovieFavorite = true
        
        // When
        sut.fetchFavoriteMovie(movieId: movieId) { isFavorite in
            // Then
            XCTAssertTrue(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, movieId)
    }
    
    func test_fetchFavoriteMovie_WhenMovieIsNotFavorite_ShouldReturnFalse() {
        // Given
        let movieId = 198884
        let expectation = XCTestExpectation(description: "Verificação de não favorito")
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.isMovieFavorite = false
        
        // When
        sut.fetchFavoriteMovie(movieId: movieId) { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, movieId)
    }
    
    func test_fetchFavoriteMovie_WhenFailure_ShouldReturnFalse() {
        // Given
        let movieId = 198884
        let expectation = XCTestExpectation(description: "Verificação de falha")
        mockFavoritesManager.shouldSucceed = false
        
        // When
        sut.fetchFavoriteMovie(movieId: movieId) { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, movieId)
    }
    
    // MARK: - fetchImageData Tests
    
    func test_fetchImageData_WithValidURL_ShouldReturnImageData() {
        // Given
        let url = "/test.jpg"
        let mockData = "test image data".data(using: .utf8)!
        let expectation = XCTestExpectation(description: "Download da imagem com sucesso")
        mockMovieImageDownloadUseCase.shouldSucceed = true
        mockMovieImageDownloadUseCase.mockImageData = mockData
        
        // When
        sut.fetchImageData(from: url) { imageData in
            // Then
            XCTAssertEqual(imageData, mockData)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastURL, url)
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastImageType, .poster)
    }
    
    func test_fetchImageData_WhenFailure_ShouldReturnNil() {
        // Given
        let url = "/test.jpg"
        let expectation = XCTestExpectation(description: "Imagem nula")
        mockMovieImageDownloadUseCase.shouldSucceed = false
        
        // When
        sut.fetchImageData(from: url) { imageData in
            // Then
            XCTAssertNil(imageData)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastURL, url)
    }
    
    func test_fetchImageData_WithSpecialCharacters_ShouldReturnImage() {
        // Given
        let url = "/test image with spaces & symbols.jpg"
        let mockData = "test data".data(using: .utf8)!
        let expectation = XCTestExpectation(description: "Donwload da imagem com caracteres especiais")
        mockMovieImageDownloadUseCase.shouldSucceed = true
        mockMovieImageDownloadUseCase.mockImageData = mockData
        
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
    
    // MARK: - openMovieDetails Tests
    
    func test_openMovieDetails_ShouldCallCoordinator() {
        // Given
        let movieId = 198884
        
        // When
        sut.openMovieDetails(with: movieId)
        
        // Then
        XCTAssertEqual(mockCoordinatorDelegate.lastMovieId, movieId)
        XCTAssertTrue(mockCoordinatorDelegate.showMovieDetailsCalled)
        XCTAssertNil(mockCoordinatorDelegate.lastUpdateDelegate)
    }
    
    func test_openMovieDetails_WithDifferentID_ShouldCallCoordinator() {
        // Given
        let movieId = 973042
        
        // When
        sut.openMovieDetails(with: movieId)
        
        // Then
        XCTAssertEqual(mockCoordinatorDelegate.lastMovieId, movieId)
        XCTAssertTrue(mockCoordinatorDelegate.showMovieDetailsCalled)
    }
    
    // MARK: - Properties Tests
    
    func test_title_ShouldReturnCorrectValue() {
        // Then
        XCTAssertEqual(sut.title, UIStrings.Navigation.favorites)
    }
    
    func test_errorMessage_ShouldReturnCorrectValue() {
        // Then
        XCTAssertEqual(sut.errorMessage, UIStrings.States.errorLoadingFavorites)
    }
    
    func test_emptyState_ShouldReturnCorrectValue() {
        // Then
        XCTAssertEqual(sut.emptyState, UIStrings.States.emptyFavorites)
    }
    
    // MARK: - Helper Methods
    
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
    
    private func createSecondTestMovie() -> Movie {
        return Movie(
            id: 973042,
            originalTitle: "Max Steel: Turbo Charged",
            posterPath: "/566jQXMLiYm1G2JEMOCiaSFM3Ad.jpg",
            voteAverage: 0,
            backdropPath: "/2cFk2AHymCALBaBfi8R2JWNmt1W.jpg",
            title: "Max Steel: Turbo Charged",
            overview: "Test overview",
            releaseDate: "2017-03-18",
            budget: 2000000,
            revenue: 1000000
        )
    }
}

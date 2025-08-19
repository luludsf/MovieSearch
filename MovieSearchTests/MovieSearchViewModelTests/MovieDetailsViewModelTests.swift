//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieDetailsViewModelTests: XCTestCase {
    
    var sut: MovieDetailsViewModel!
    var mockDelegate: MockMovieDetailsViewModelDelegate!
    var mockUpdateDelegate: MockMovieSearchResultViewControllerUpdateDelegate!
    var mockFavoritesManager: MockFavoritesManager!
    var mockMovieDetailsUseCase: MockMovieDetailsUseCase!
    var mockMovieImageDownloadUseCase: MockMovieImageDownloadUseCase!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockMovieDetailsViewModelDelegate()
        mockUpdateDelegate = MockMovieSearchResultViewControllerUpdateDelegate()
        mockFavoritesManager = MockFavoritesManager()
        mockMovieDetailsUseCase = MockMovieDetailsUseCase()
        mockMovieImageDownloadUseCase = MockMovieImageDownloadUseCase()
        
        sut = MovieDetailsViewModel(
            favoritesManager: mockFavoritesManager,
            movieDetailsUseCase: mockMovieDetailsUseCase,
            movieImageDownloadUseCase: mockMovieImageDownloadUseCase,
            movieId: 198884
        )
        
        sut.delegate = mockDelegate
        sut.updateDelegate = mockUpdateDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockDelegate = nil
        mockUpdateDelegate = nil
        mockFavoritesManager = nil
        mockMovieDetailsUseCase = nil
        mockMovieImageDownloadUseCase = nil
        super.tearDown()
    }
    
    // MARK: - fetchMovieDetails Tests
    
    func test_fetchMovieDetails_WhenSuccessful_ShouldUpdateStateAndNotifyDelegate() {
        // Given
        let expectation = XCTestExpectation(description: "Conclusão dos detalhes do filme")
        let mockMovie = createTestMovie()
        mockMovieDetailsUseCase.shouldSucceed = true
        mockMovieDetailsUseCase.mockMovie = mockMovie
        
        mockDelegate.didFetchMovieCalled = { movie in
            XCTAssertEqual(movie.id, 198884)
            XCTAssertEqual(movie.title, "Barbie and the Sensations: Rockin' Back to Earth")
            expectation.fulfill()
        }
        
        // When
        sut.fetchMovieDetails()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchMovieDetails_WhenFailure_ShouldNotifyDelegate() {
        // Given
        let expectation = XCTestExpectation(description: "Conclusão do erro")
        mockMovieDetailsUseCase.shouldSucceed = false
        mockMovieDetailsUseCase.mockError = .serviceUnavailable
        
        mockDelegate.didFailWithErrorCalled = { error in
            XCTAssertEqual(error, "Serviço indisponível")
            expectation.fulfill()
        }
        
        // When
        sut.fetchMovieDetails()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchMovieDetails_WhenCalledMultipleTimes_ShouldNotifyDelegate() {
        // Given
        let expectation = XCTestExpectation(description: "Múltiplas chamadas")
        expectation.expectedFulfillmentCount = 2
        
        let mockMovie = createTestMovie()
        mockMovieDetailsUseCase.shouldSucceed = true
        mockMovieDetailsUseCase.mockMovie = mockMovie
        
        mockDelegate.didFetchMovieCalled = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.fetchMovieDetails()
        sut.fetchMovieDetails()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchMovieDetails_WithBackdropPath_ShouldFetchImage() {
        // Given
        let expectation = XCTestExpectation(description: "Conclusão do download da imagem")
        let mockMovie = createTestMovie()
        mockMovieDetailsUseCase.shouldSucceed = true
        mockMovieDetailsUseCase.mockMovie = mockMovie
        
        let mockImageData = "backdrop image data".data(using: .utf8)!
        mockMovieImageDownloadUseCase.shouldSucceed = true
        mockMovieImageDownloadUseCase.mockImageData = mockImageData
        
        mockDelegate.didFetchImageDataCalled = { imageData in
            XCTAssertEqual(imageData, mockImageData)
            expectation.fulfill()
        }
        
        // When
        sut.fetchMovieDetails()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastURL, "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg")
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastImageType, .backdrop)
    }
    
    func test_fetchMovieDetails_WithoutBackdropPath_ShouldNotFetchImage() {
        // Given
        let mockMovie = createTestMovieWithoutBackdrop()
        mockMovieDetailsUseCase.shouldSucceed = true
        mockMovieDetailsUseCase.mockMovie = mockMovie
        
        let expectation = XCTestExpectation(description: "Detalhes do filme sem imagem")
        
        mockDelegate.didFetchMovieCalled = { movie in
            XCTAssertEqual(movie.id, 198884)
            XCTAssertNil(movie.backdropPath)
            expectation.fulfill()
        }
        
        // When
        sut.fetchMovieDetails()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(mockMovieImageDownloadUseCase.lastURL)
    }
    
    // MARK: - fetchImageData Tests
    
    func test_fetchImageData_WithValidURL_ShouldReturnImageData() {
        // Given
        let url = "/test.jpg"
        let mockData = "test image data".data(using: .utf8)!
        let expectation = XCTestExpectation(description: "Conclusão da imagem")
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
        XCTAssertEqual(mockMovieImageDownloadUseCase.lastImageType, .backdrop)
    }
    
    func test_fetchImageData_WhenFailure_ShouldReturnNil() {
        // Given
        let url = "/test.jpg"
        let expectation = XCTestExpectation(description: "Falha no download da imagem")
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
    
    // MARK: - manageFavoriteMovie Tests
    
    func test_manageFavoriteMovie_WhenSuccessful_ShouldNotifyUpdateDelegate() {
        // Given
        let expectation = XCTestExpectation(description: "Conclusão do gerenciamento de favorito")
        let mockMovie = createTestMovie()
        mockMovieDetailsUseCase.shouldSucceed = true
        mockMovieDetailsUseCase.mockMovie = mockMovie
        mockFavoritesManager.shouldSucceed = true
        
        sut.fetchMovieDetails()

        mockUpdateDelegate.reloadViewClosure = { [weak self] in
            // Then
            guard let self else {
                XCTFail("test_manageFavoriteMovie_WhenSuccessful failed")
                return
            }
            XCTAssertTrue(self.mockUpdateDelegate.reloadViewCalled)
            XCTAssertEqual(mockFavoritesManager.lastMovie?.id, 198884)
            XCTAssertEqual(mockFavoritesManager.lastIsFavorite, true)
            expectation.fulfill()
        }
        
        // When
        sut.manageFavoriteMovie(isFavorite: true) { _ in }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_manageFavoriteMovie_WhenFailure_ShouldNotNotifyUpdateDelegate() {
        // Given
        let expectation = XCTestExpectation(description: "Falha no gerenciamento de favorito")
        let mockMovie = createTestMovie()
        mockMovieDetailsUseCase.shouldSucceed = true
        mockMovieDetailsUseCase.mockMovie = mockMovie
        
        sut.fetchMovieDetails()
        
        mockFavoritesManager.shouldSucceed = false
        
        // When
        sut.manageFavoriteMovie(isFavorite: false) { [weak self] success in
            guard let self else { return }
            XCTAssertNil(self.mockUpdateDelegate.reloadViewClosure)
            XCTAssertFalse(self.mockUpdateDelegate.reloadViewCalled)
            expectation.fulfill()
        }
                
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - isFavoriteMovie Tests
    
    func test_isFavoriteMovie_ShouldCallFavoritesManager() {
        // Given
        let expectation = XCTestExpectation(description: "Conclusão da verificação de favorito")
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.isMovieFavorite = true
        
        // When
        sut.isFavoriteMovie { isFavorite in
            // Then
            XCTAssertTrue(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, 198884)
    }
    
    func test_isFavoriteMovie_WhenNotFavorite_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Verificação de não favorito")
        mockFavoritesManager.shouldSucceed = true
        mockFavoritesManager.isMovieFavorite = false
        
        // When
        sut.isFavoriteMovie { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, 198884)
    }
    
    func test_isFavoriteMovie_WhenFailure_ShouldReturnFalse() {
        // Given
        let expectation = XCTestExpectation(description: "Verificação de falha")
        mockFavoritesManager.shouldSucceed = false
        
        // When
        sut.isFavoriteMovie { isFavorite in
            // Then
            XCTAssertFalse(isFavorite)
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavoritesManager.lastMovieId, 198884)
    }
    
    // MARK: - Properties Tests
    
    func test_title_ShouldReturnCorrectValue() {
        // Then
        XCTAssertEqual(sut.title, UIStrings.Navigation.details)
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
    
    private func createTestMovieWithoutBackdrop() -> Movie {
        return Movie(
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: nil,
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Test overview",
            releaseDate: "1987-09-27",
            budget: 1000000,
            revenue: 5000000
        )
    }
}

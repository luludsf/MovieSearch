//
//  MovieImageDownloadUseCaseTests.swift
//  MovieSearchDomainTests
//
//  Created by Luana Duarte on 15/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieImageDownloadUseCaseTests: XCTestCase {
    
    var sut: MovieImageDownloadUseCase!
    var mockRepository: MockMovieSearchRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieSearchRepository()
        sut = MovieImageDownloadUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_getMovieImage_WhenSuccessful_ShouldReturnImageData() {
        // Given
        let expectation = XCTestExpectation(description: "Imagem retornada com sucesso")
        let mockData = "test image data".data(using: .utf8)!
        mockRepository.mockImageData = mockData
        mockRepository.shouldSuceed = true
        
        // When
        sut.getMovieImage(from: "/test.jpg", with: .poster) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
            case .failure:
                XCTFail("getMovieImageUseCase não deveria falhar")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_getMovieImage_WhenFail_ShouldReturnError() {
        // Given
        let expectation = XCTestExpectation(description: "Imagem não retornada")
        
        mockRepository.mockError = .serviceUnavailable
        mockRepository.shouldSuceed = false
        
        // When
        sut.getMovieImage(from: "/test.jpg", with: .poster) { result in
            // Then
            switch result {
            case .success(let data):
                XCTFail("getMovieImage não ser sucedido")
            case .failure(let error):
                XCTAssertEqual(error, .serviceUnavailable)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

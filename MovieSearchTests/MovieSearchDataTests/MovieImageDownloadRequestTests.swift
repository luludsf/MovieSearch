//
//  MovieImageDownloadRequestTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieImageDownloadRequestTests: XCTestCase {
    
    func test_movieImageDownload_ShouldHaveCorrectProperties() {
        // Given
        let request = MovieImageDownloadRequest.movieImageDownload("/test.jpg", .poster)
        
        // Then
        XCTAssertEqual(request.host, "image.tmdb.org")
        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.version, "")
        XCTAssertEqual(request.method, .GET)
        XCTAssertEqual(request.path, "/t/p/w500/test.jpg")
        XCTAssertNil(request.headers)
        XCTAssertNil(request.bodyParams)
        XCTAssertNil(request.queryParams)
    }
    
    func test_movieImageDownload_WithBackdrop_ShouldHaveCorrectPath() {
        // Given
        let request = MovieImageDownloadRequest.movieImageDownload("/backdrop.jpg", .backdrop)
        
        // Then
        XCTAssertEqual(request.path, "/t/p/original/backdrop.jpg")
    }
}

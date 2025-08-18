//
//  MovieSearchRequestTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieSearchRequestTests: XCTestCase {
    
    func test_movieSearch_ShouldHaveCorrectProperties() {
        // Given
        let request = MovieSearchRequest.movieSearch(query: "test", page: 1)
        
        // Then
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.version, "3")
        XCTAssertEqual(request.method, .GET)
        XCTAssertEqual(request.path, "/3/search/movie")
        XCTAssertEqual(request.queryParams?["query"], "test")
        XCTAssertEqual(request.queryParams?["page"], "1")
        XCTAssertEqual(request.queryParams?["language"], "pt-BR")
        XCTAssertNotNil(request.queryParams?["api_key"])
        XCTAssertNil(request.headers)
        XCTAssertNil(request.bodyParams)
    }
    
    func test_movieSearch_WhenPageIsNil_ShouldNotIncludePageParam() {
        // Given
        let request = MovieSearchRequest.movieSearch(query: "test", page: nil)
        
        // Then
        XCTAssertNil(request.queryParams?["page"])
    }
    
    func test_movieDetails_ShouldHaveCorrectProperties() {
        // Given
        let request = MovieSearchRequest.movieDetails(id: 123)
        
        // Then
        XCTAssertEqual(request.host, "api.themoviedb.org")
        XCTAssertEqual(request.scheme, "https")
        XCTAssertEqual(request.version, "3")
        XCTAssertEqual(request.method, .GET)
        XCTAssertEqual(request.path, "/3/movie/123")
        XCTAssertEqual(request.queryParams?["language"], "pt-BR")
        XCTAssertNotNil(request.queryParams?["api_key"])
        XCTAssertNil(request.queryParams?["query"])
        XCTAssertNil(request.queryParams?["page"])
        XCTAssertNil(request.headers)
        XCTAssertNil(request.bodyParams)
    }
}

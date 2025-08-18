//
//  MovieSearchResponseTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieSearchResponseTests: XCTestCase {
    
    func test_MovieSearchResponse_ShouldBeCodable() {
        // Given
        let json = """
        {
            "results": [
                {
                    "id": 1,
                    "original_title": "Movie 1",
                    "poster_path": "/poster1.jpg",
                    "vote_average": 8.0,
                    "backdrop_path": "/backdrop1.jpg",
                    "title": "Movie 1",
                    "overview": "Overview 1",
                    "release_date": "2023-01-01",
                    "budget": 1000000,
                    "revenue": 5000000
                }
            ],
            "page": 1,
            "total_pages": 5,
            "total_results": 100
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try? decoder.decode(MovieSearchRespone.self, from: json)
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.results?.count, 1)
        XCTAssertEqual(response?.page, 1)
        XCTAssertEqual(response?.totalPages, 5)
        XCTAssertEqual(response?.totalResults, 100)
    }
    
    func test_MovieSearchResponse_WithEmptyResults_ShouldBeCodable() {
        // Given
        let json = """
        {
            "results": [],
            "page": 1,
            "total_pages": 0,
            "total_results": 0
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try? decoder.decode(MovieSearchRespone.self, from: json)
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.results?.count, 0)
        XCTAssertEqual(response?.page, 1)
        XCTAssertEqual(response?.totalPages, 0)
        XCTAssertEqual(response?.totalResults, 0)
    }
}

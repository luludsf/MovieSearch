//
//  MovieResponseTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import XCTest
@testable import MovieSearch

final class MovieResponseTests: XCTestCase {
    
    func test_MovieResponse_ShouldBeCodable() {
        // Given
        let json = """
        {
            "id": 123,
            "original_title": "Original Title",
            "poster_path": "/poster.jpg",
            "vote_average": 8.5,
            "backdrop_path": "/backdrop.jpg",
            "title": "English Title",
            "overview": "Movie overview",
            "release_date": "2023-12-25",
            "budget": 5000000,
            "revenue": 10000000
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let movieResponse = try? decoder.decode(MovieResponse.self, from: json)
        
        // Then
        XCTAssertNotNil(movieResponse)
        XCTAssertEqual(movieResponse?.id, 123)
        XCTAssertEqual(movieResponse?.originalTitle, "Original Title")
        XCTAssertEqual(movieResponse?.posterPath, "/poster.jpg")
        XCTAssertEqual(movieResponse?.voteAverage, 8.5)
        XCTAssertEqual(movieResponse?.backdropPath, "/backdrop.jpg")
        XCTAssertEqual(movieResponse?.title, "English Title")
        XCTAssertEqual(movieResponse?.overview, "Movie overview")
        XCTAssertEqual(movieResponse?.releaseDate, "2023-12-25")
        XCTAssertEqual(movieResponse?.budget, 5000000)
        XCTAssertEqual(movieResponse?.revenue, 10000000)
    }
}

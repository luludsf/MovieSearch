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
                    "id": 198884,
                    "original_title": "Barbie and The Sensations: Rockin' Back to Earth",
                    "poster_path": "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
                    "vote_average": 7.5,
                    "backdrop_path": "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
                    "title": "Barbie and the Sensations: Rockin' Back to Earth",
                    "overview": "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
                    "release_date": "1987-09-27",
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

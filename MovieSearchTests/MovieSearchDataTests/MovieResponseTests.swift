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
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let movieResponse = try? decoder.decode(MovieResponse.self, from: json)
        
        // Then
        XCTAssertNotNil(movieResponse)
        XCTAssertEqual(movieResponse?.id, 198884)
        XCTAssertEqual(movieResponse?.originalTitle, "Barbie and The Sensations: Rockin' Back to Earth")
        XCTAssertEqual(movieResponse?.posterPath, "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg")
        XCTAssertEqual(movieResponse?.voteAverage, 7.5)
        XCTAssertEqual(movieResponse?.backdropPath, "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg")
        XCTAssertEqual(movieResponse?.title, "Barbie and the Sensations: Rockin' Back to Earth")
        XCTAssertEqual(movieResponse?.overview, "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.")
        XCTAssertEqual(movieResponse?.releaseDate, "1987-09-27")
        XCTAssertEqual(movieResponse?.budget, 1000000)
        XCTAssertEqual(movieResponse?.revenue, 5000000)
    }
}

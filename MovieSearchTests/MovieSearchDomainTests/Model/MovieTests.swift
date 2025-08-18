//
//  MovieTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//


import XCTest
@testable import MovieSearch

// MARK: - Movie Tests

final class MovieTests: XCTestCase {
    
    func test_Movie_ShouldHaveCorrectProperties() {
        // Given
        let movie = Movie(
            id: 198884,
            originalTitle: "Barbie and The Sensations: Rockin' Back to Earth",
            posterPath: "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg",
            voteAverage: 7.5,
            backdropPath: "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg",
            title: "Barbie and the Sensations: Rockin' Back to Earth",
            overview: "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.",
            releaseDate: "1987-09-27",
            budget: 1000000,
            revenue: 5000000
        )
        
        // Then
        XCTAssertEqual(movie.id, 198884)
        XCTAssertEqual(movie.originalTitle, "Barbie and The Sensations: Rockin' Back to Earth")
        XCTAssertEqual(movie.posterPath, "/vUCqvymxUwYxp9H6jw5R5UiaeE5.jpg")
        XCTAssertEqual(movie.voteAverage, 7.5)
        XCTAssertEqual(movie.backdropPath, "/ijfPu1IaDjy1PPUMh57PihHlRYf.jpg")
        XCTAssertEqual(movie.title, "Barbie and the Sensations: Rockin' Back to Earth")
        XCTAssertEqual(movie.overview, "Following their concert for world peace in outer space, Barbie and her band the Rockers are going back home. During the trip back to Earth, the band's space shuttle inadvertently enters a time warp. Upon landing at an airport, they meet Dr. Merrihew and his daughter Kim and soon learn that they have been transported back to 1959. The band then decides to go on a tour around the city alongside Kim. After a performance at Cape Canaveral, Dr. Merrihew helps Barbie and the Rockers return to their time. Back in the present, they stage a big concert in New York City, where Barbie is reunited with an adult Kim and introduced to her daughter Megan.")
        XCTAssertEqual(movie.releaseDate, "1987-09-27")
        XCTAssertEqual(movie.budget, 1000000)
        XCTAssertEqual(movie.revenue, 5000000)
    }
}
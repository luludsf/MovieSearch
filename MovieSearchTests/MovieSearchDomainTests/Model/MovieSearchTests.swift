//
//  MovieSearchTests.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//


import XCTest
@testable import MovieSearch

final class MovieSearchTests: XCTestCase {
    
    func test_MovieSearch_whenSucceds_ShouldCreateCorrectObject() {
        // Given
        let movies = [
            Movie(
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
            ),
            Movie(
                id: 973042,
                originalTitle: "Max Steel: Turbo Charged",
                posterPath: "/566jQXMLiYm1G2JEMOCiaSFM3Ad.jpg",
                voteAverage: 0,
                backdropPath: "/2cFk2AHymCALBaBfi8R2JWNmt1W.jpg",
                title: "Max Steel: Turbo Charged",
                overview: "Max must master an all-new, more powerful form of turbo energy if he wants to defeat Terrorax.",
                releaseDate: "2017-03-18",
                budget: 2000000,
                revenue: 1000000
            )
        ]
        let movieSearch = MovieSearch(
            results: movies,
            page: 1,
            totalPages: 5,
            totalResults: 100
        )
        
        // Then
        XCTAssertEqual(movieSearch.results?.count, 2)
        XCTAssertEqual(movieSearch.results?.first?.id, 198884)
        XCTAssertEqual(movieSearch.results?.last?.id, 973042)
        XCTAssertEqual(movieSearch.page, 1)
        XCTAssertEqual(movieSearch.totalPages, 5)
        XCTAssertEqual(movieSearch.totalResults, 100)
    }
}

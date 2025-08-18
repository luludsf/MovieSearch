//
//  MovieResponse.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

struct MovieResponse: Codable {
    let id: Int
    let originalTitle: String?
    let posterPath: String?
    let voteAverage: Double
    let backdropPath: String?
    let title: String?
    let overview: String?
    let releaseDate: String?
    let budget: Int?
    let revenue: Int?
}

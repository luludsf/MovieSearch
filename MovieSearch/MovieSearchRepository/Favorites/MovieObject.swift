//
//  MovieObject.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import Foundation
import SwiftData

@Model
final class MovieObject {
    var id: Int
    var originalTitle: String?
    var posterPath: String?
    var voteAverage: Double
    var backdropPath: String?
    var title: String?
    var overview: String?
    var releaseDate: String?
    var budget: Int?
    var revenue: Int?

    init(
        id: Int,
        originalTitle: String? = nil,
        posterPath: String? = nil,
        voteAverage: Double,
        backdropPath: String? = nil,
        title: String? = nil,
        overview: String? = nil,
        releaseDate: String? = nil,
        budget: Int? = nil,
        revenue: Int? = nil
    ) {
        self.id = id
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.backdropPath = backdropPath
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.budget = budget
        self.revenue = revenue
    }
}

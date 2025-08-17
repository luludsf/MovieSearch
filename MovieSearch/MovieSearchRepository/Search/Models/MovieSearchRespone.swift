//
//  MovieSearchRespone.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

struct MovieSearchRespone: Codable {
    let results: [MovieResponse]?
    let page: Int
    let totalPages: Int
    let totalResults: Int
}

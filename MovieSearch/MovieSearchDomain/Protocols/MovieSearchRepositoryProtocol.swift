//
//  MovieSearchRepositoryProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import Foundation

protocol MovieSearchRepositoryProtocol {
    func getSearch(
        from query: String,
        page: Int?,
        shouldIgnoreCache: Bool,
        completion: @escaping (Result<MovieSearch, MovieSearchError>) -> Void
    )
    
    func getMovieDetails(
        with id: Int,
        shouldIgnoreCache: Bool,
        completion: @escaping (Result<Movie, MovieSearchError>) -> Void
    )
    
    func getMovieImage(
        from url: String,
        with imageType: ImageType,
        shouldIgnoreCache: Bool,
        completion: @escaping (Data?) -> Void
    )
}

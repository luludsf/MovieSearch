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
        completion: @escaping (Result<MovieSearch, MovieSearchError>) -> Void
    )
    
    func getMovieDetails(
        with id: Int,
        completion: @escaping (Result<Movie, MovieSearchError>) -> Void
    )
    
    func getMovieImage(
        from url: String,
        with imageType: ImageType,
        completion: @escaping (Result<Data?, MovieSearchError>) -> Void
    )
}

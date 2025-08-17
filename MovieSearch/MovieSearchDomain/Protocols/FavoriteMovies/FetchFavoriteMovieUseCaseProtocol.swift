//
//  FetchFavoriteMovieUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol FetchFavoriteMovieUseCaseProtocol {
    func execute(_ movieId: Int, completion: @escaping (Bool) -> Void)
}

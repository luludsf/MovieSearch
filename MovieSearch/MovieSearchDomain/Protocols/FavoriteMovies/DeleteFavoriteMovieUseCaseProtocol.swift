//
//  DeleteFavoriteMovieUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol DeleteFavoriteMovieUseCaseProtocol {
    func execute(_ movie: Movie, completion: @escaping (Bool) -> Void)
}

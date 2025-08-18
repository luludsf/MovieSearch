//
//  MovieDetailsUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol MovieDetailsUseCaseProtocol {
    func execute(id: Int, completion: @escaping ((Result<Movie, MovieSearchError>) -> Void))
}

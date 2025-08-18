//
//  MovieDetailsUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

// TODO: Remover o shouldIgnoreCache se eu não for impl cache
protocol MovieDetailsUseCaseProtocol {
    func execute(id: Int, shouldIgnoreCache: Bool, completion: @escaping ((Result<Movie, MovieSearchError>) -> Void))
}

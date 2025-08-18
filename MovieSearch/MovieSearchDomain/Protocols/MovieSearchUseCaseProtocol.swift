//
//  MovieSearchUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol MovieSearchUseCaseProtocol {
    func execute(query: String, page: Int?, completion: @escaping ((Result<MovieSearch, MovieSearchError>) -> Void))
}

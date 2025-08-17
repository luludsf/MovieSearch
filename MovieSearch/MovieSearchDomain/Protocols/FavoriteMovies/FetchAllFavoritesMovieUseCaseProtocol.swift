//
//  FetchAllFavoritesMovieUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol FetchAllFavoritesMovieUseCaseProtocol {
    func execute(completion: @escaping ([Movie]?) -> Void)
}

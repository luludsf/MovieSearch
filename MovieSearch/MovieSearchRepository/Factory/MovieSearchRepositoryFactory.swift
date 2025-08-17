//
//  MovieSearchRepositoryFactory.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import SwiftData

class MovieSearchRepositoryFactory: MovieSearchRepositoryFactoryProtocol {

    func makeMovieSearchRepository() -> MovieSearchRepositoryProtocol {
        let networking = URLSessionClient()
        return MovieSearchRepository(networking: networking)
    }
    
    func makeFavoriteMoviesRepository() -> FavoriteMoviesRepositoryProtocol {
        let modelContainer: ModelContainer? = try? ModelContainer(for: MovieObject.self)
        let service = FavoriteMovieService(modelContainer: modelContainer)
        return FavoriteMoviesRepository(service: service)
    }
}

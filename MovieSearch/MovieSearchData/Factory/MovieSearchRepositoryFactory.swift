//
//  MovieSearchRepositoryFactory.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import SwiftData

class MovieSearchRepositoryFactory: MovieSearchRepositoryFactoryProtocol {
    
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }

    func makeMovieSearchRepository() -> MovieSearchRepositoryProtocol {
        return MovieSearchRepository(networking: networking)
    }
    
    func makeFavoriteMoviesRepository() -> FavoriteMoviesRepositoryProtocol {
        let modelContainer: ModelContainer? = try? ModelContainer(for: MovieObject.self)
        let dataSource = FavoriteMovieSwiftDataDataSource(modelContainer: modelContainer)
        return FavoriteMoviesRepository(dataSource: dataSource)
    }
}

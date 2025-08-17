//
//  FavoriteMoviesRepository.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

final class FavoriteMoviesRepository: FavoriteMoviesRepositoryProtocol {

    private let service: FavoriteMovieServiceProtocol
    
    init(service: FavoriteMovieServiceProtocol) {
        self.service = service
    }
    
    func saveFavoriteMovie(_ movie: Movie) {
        let movieObject = MovieObject(
            id: movie.id,
            originalTitle: movie.originalTitle,
            posterPath: movie.posterPath,
            voteAverage: movie.voteAverage,
            backdropPath: movie.backdropPath,
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            budget: movie.budget,
            revenue: movie.revenue
        )
        service.saveFavoriteMovie(movieObject)
    }
    
    // TODO: Fazer error handling do catch
    func deleteFavoriteMovie(_ movie: Movie) throws {
        let movieObject = MovieObject(
            id: movie.id,
            originalTitle: movie.originalTitle,
            posterPath: movie.posterPath,
            voteAverage: movie.voteAverage,
            backdropPath: movie.backdropPath,
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            budget: movie.budget,
            revenue: movie.revenue
        )
        try? service.deleteFavoriteMovie(movieObject)
    }
    
    // TODO: Fazer error handling do catch
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void) {
        service.fetchAllFavoriteMovies { moviesObject in
            let movies = moviesObject?.map {
                Movie(
                    id: $0.id,
                    originalTitle: $0.originalTitle,
                    posterPath: $0.posterPath,
                    voteAverage: $0.voteAverage,
                    backdropPath: $0.backdropPath,
                    title: $0.title,
                    overview: $0.overview,
                    releaseDate: $0.releaseDate,
                    budget: $0.budget,
                    revenue: $0.revenue
                )
            }
            completion(movies)
        }
    }
    
    func fetchFavoriteMovie(id: Int, completion: @escaping (Bool) -> Void) {
        service.fetchFavoriteMovie(id: id, completion: completion)
    }
}

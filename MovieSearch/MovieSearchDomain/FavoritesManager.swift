//
//  FavoritesManager.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class FavoritesManager: FavoritesManagerProtocol {
    
    private let saveFavoriteMovieUseCase: SaveFavoriteMovieUseCaseProtocol
    private let deleteFavoriteMovieUseCase: DeleteFavoriteMovieUseCaseProtocol
    private let fetchFavoriteMovieUseCase: FetchFavoriteMovieUseCaseProtocol
    private let fetchAllFavoritesMovieUseCase: FetchAllFavoritesMovieUseCaseProtocol

    init(saveFavoriteMovieUseCase: SaveFavoriteMovieUseCaseProtocol, deleteFavoriteMovieUseCase: DeleteFavoriteMovieUseCaseProtocol, fetchFavoriteMovieUseCase: FetchFavoriteMovieUseCaseProtocol, fetchAllFavoritesMovieUseCase: FetchAllFavoritesMovieUseCaseProtocol) {
        self.saveFavoriteMovieUseCase = saveFavoriteMovieUseCase
        self.deleteFavoriteMovieUseCase = deleteFavoriteMovieUseCase
        self.fetchFavoriteMovieUseCase = fetchFavoriteMovieUseCase
        self.fetchAllFavoritesMovieUseCase = fetchAllFavoritesMovieUseCase
    }
    
    func saveFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        saveFavoriteMovieUseCase.execute(movie, completion: completion)
    }
    
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        deleteFavoriteMovieUseCase.execute(movie, completion: completion)
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void) {
        fetchAllFavoritesMovieUseCase.execute { movies in
            completion(movies)
        }
    }
    
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void) {
        fetchFavoriteMovieUseCase.execute(movieId, completion: completion)
    }
    
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void) {
        fetchFavoriteMovieUseCase.execute(selectedMovie.id) { isSaved in
            if !isSaved && isFavorite {
                self.saveFavoriteMovieUseCase.execute(selectedMovie, completion: completion)
            }
            
            if isSaved && !isFavorite {
                self.deleteFavoriteMovieUseCase.execute(selectedMovie, completion: completion)
            }
        }
    }
}

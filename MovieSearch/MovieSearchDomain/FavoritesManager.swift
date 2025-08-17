//
//  FavoritesManager.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol FavoritesManagerProtocol {
    func saveFavoriteMovie(_ movie: Movie)
    func deleteFavoriteMovie(_ movie: Movie)
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void)
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void)
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie)
}

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
    
    func saveFavoriteMovie(_ movie: Movie) {
        saveFavoriteMovieUseCase.execute(movie)
    }
    
    func deleteFavoriteMovie(_ movie: Movie) {
        deleteFavoriteMovieUseCase.execute(movie)
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void) {
        fetchAllFavoritesMovieUseCase.execute { movies in
            completion(movies)
        }
    }
    
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void) {
        fetchFavoriteMovieUseCase.execute(movieId, completion: completion)
    }
    
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie) {
        fetchFavoriteMovieUseCase.execute(selectedMovie.id) { isSaved in
            if !isSaved && isFavorite {
                self.saveFavoriteMovieUseCase.execute(selectedMovie)
            }
            
            if isSaved && !isFavorite {
                self.deleteFavoriteMovieUseCase.execute(selectedMovie)
            }
        }
    }
}

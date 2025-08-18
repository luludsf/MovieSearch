//
//  FetchAllFavoritesMovieUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class FetchAllFavoritesMovieUseCase: FetchAllFavoritesMovieUseCaseProtocol {
    
    private let repository: FavoriteMoviesRepositoryProtocol
    
    init(repository: FavoriteMoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping ([Movie]?) -> Void) {
        repository.fetchAllFavoriteMovies { movies in
            completion(movies)
        }
    }
}

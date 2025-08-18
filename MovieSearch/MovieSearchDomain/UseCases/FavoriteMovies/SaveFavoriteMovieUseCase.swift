//
//  SaveFavoriteMovieUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class SaveFavoriteMovieUseCase: SaveFavoriteMovieUseCaseProtocol {
    
    private let repository: FavoriteMoviesRepositoryProtocol
    
    init(repository: FavoriteMoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        repository.saveFavoriteMovie(movie, completion: completion)
    }
}

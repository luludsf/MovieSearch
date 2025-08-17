//
//  FetchFavoriteMovieUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class FetchFavoriteMovieUseCase: FetchFavoriteMovieUseCaseProtocol {
    
    private let repository: FavoriteMoviesRepositoryProtocol
    
    init(repository: FavoriteMoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    // TODO: VERIFICAR ERROR
    func execute(_ movieId: Int, completion: @escaping (Bool) -> Void) {
        repository.fetchFavoriteMovie(id: movieId, completion: completion)
    }
}

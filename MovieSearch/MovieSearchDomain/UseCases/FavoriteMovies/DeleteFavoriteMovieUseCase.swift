//
//  DeleteFavoriteMovieUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class DeleteFavoriteMovieUseCase: DeleteFavoriteMovieUseCaseProtocol {
    
    private let repository: FavoriteMoviesRepositoryProtocol
    
    init(repository: FavoriteMoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    // TODO: VERIFICAR ERROR
    func execute(_ movie: Movie) {
        try? repository.deleteFavoriteMovie(movie)
    }
}

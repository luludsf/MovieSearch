//
//  MovieSearchDomainFactory.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class MovieSearchDomainFactory: MovieSearchDomainFactoryProtocol {
    
    private let movieSearchRepositoryFactory: MovieSearchRepositoryFactoryProtocol
    
    init(movieSearchRepositoryFactory: MovieSearchRepositoryFactoryProtocol) {
        self.movieSearchRepositoryFactory = movieSearchRepositoryFactory
    }
    
    func makeDeleteFavoriteMovieUseCase() -> DeleteFavoriteMovieUseCaseProtocol {
        DeleteFavoriteMovieUseCase(repository: movieSearchRepositoryFactory.makeFavoriteMoviesRepository())
    }
    
    func makeSaveFavoriteMovieUseCase() -> SaveFavoriteMovieUseCaseProtocol {
        SaveFavoriteMovieUseCase(repository: movieSearchRepositoryFactory.makeFavoriteMoviesRepository())
    }
    
    func makeFetchAllFavoritesMovieUseCase() -> FetchAllFavoritesMovieUseCaseProtocol {
        FetchAllFavoritesMovieUseCase(repository: movieSearchRepositoryFactory.makeFavoriteMoviesRepository())
    }
    
    func makeFetchFavoriteMovieUseCase() -> FetchFavoriteMovieUseCaseProtocol {
        FetchFavoriteMovieUseCase(repository: movieSearchRepositoryFactory.makeFavoriteMoviesRepository())
    }
    
    func makeMovieImageDownloadUseCase() -> MovieImageDownloadUseCaseProtocol {
        MovieImageDownloadUseCase(repository: movieSearchRepositoryFactory.makeMovieSearchRepository())
    }
    
    func makeFavoritesManagerProtocol() -> FavoritesManagerProtocol {
        FavoritesManager(
            saveFavoriteMovieUseCase: makeSaveFavoriteMovieUseCase(),
            deleteFavoriteMovieUseCase: makeDeleteFavoriteMovieUseCase(),
            fetchFavoriteMovieUseCase: makeFetchFavoriteMovieUseCase(),
            fetchAllFavoritesMovieUseCase: makeFetchAllFavoritesMovieUseCase()
        )
    }
    
    func makeMovieDetailsUseCase() -> any MovieDetailsUseCaseProtocol {
        MovieDetailsUseCase(repository: movieSearchRepositoryFactory.makeMovieSearchRepository())
    }
    
    func makeMovieSearchUseCase() -> any MovieSearchUseCaseProtocol {
        MovieSearchUseCase(repository: movieSearchRepositoryFactory.makeMovieSearchRepository())
    }
}

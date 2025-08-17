//
//  MovieSearchDomainFactoryProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol MovieSearchDomainFactoryProtocol {
    func makeDeleteFavoriteMovieUseCase() -> DeleteFavoriteMovieUseCaseProtocol
    func makeSaveFavoriteMovieUseCase() -> SaveFavoriteMovieUseCaseProtocol
    func makeFetchAllFavoritesMovieUseCase() -> FetchAllFavoritesMovieUseCaseProtocol
    func makeFetchFavoriteMovieUseCase() -> FetchFavoriteMovieUseCaseProtocol
    func makeFavoritesManagerProtocol() -> FavoritesManagerProtocol
    func makeMovieImageDownloadUseCase() -> MovieImageDownloadUseCaseProtocol
    func makeMovieDetailsUseCase() -> MovieDetailsUseCaseProtocol
    func makeMovieSearchUseCase() -> MovieSearchUseCaseProtocol
}

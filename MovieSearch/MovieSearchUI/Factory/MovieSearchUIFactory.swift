//
//  MovieSearchUIFactory.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import SwiftData

class MovieSearchUIFactory: MovieSearchUIFactoryProtocol {
    
    private let movieSearchDomainFactory: MovieSearchDomainFactoryProtocol
    
    init(movieSearchDomainFactory: MovieSearchDomainFactoryProtocol) {
        self.movieSearchDomainFactory = movieSearchDomainFactory
    }
    
    func makeFavoriteMoviesViewController(delegate: CoordinatorDelegate?) -> FavoriteMoviesViewController {
        let viewModel = FavoriteMoviesViewModel(
            favoritesManager: movieSearchDomainFactory.makeFavoritesManagerProtocol(),
            movieImageDownloadUseCase: movieSearchDomainFactory.makeMovieImageDownloadUseCase()
        )
        
        viewModel.coordinatorDelegate = delegate
        let view = MoviesGridView()
        return FavoriteMoviesViewController(contentView: view, viewModel: viewModel)
    }
    
    func makeMovieDetailsViewController(movieId: Int, updateDelegate: MovieSearchResultViewControllerUpdateDelegate) -> MovieDetailsViewController {
        let viewModel = MovieDetailsViewModel(
            favoritesManager: movieSearchDomainFactory.makeFavoritesManagerProtocol(),
            movieDetailsUseCase: movieSearchDomainFactory.makeMovieDetailsUseCase(),
            movieImageDownloadUseCase: movieSearchDomainFactory.makeMovieImageDownloadUseCase(),
            movieId: movieId
        )
        
        viewModel.updateDelegate = updateDelegate
        let view = MovieDetailView()
        return MovieDetailsViewController(contentView: view, viewModel: viewModel)
    }
    
    func makeMovieSearchViewController(delegate: CoordinatorDelegate?) -> MovieSearchViewController {
        let movieSearchView = MovieSearchView()
        let movieSearchViewModel = MovieSearchViewModel()
        movieSearchViewModel.coordinatorDelegate = delegate
        return MovieSearchViewController(searchView: movieSearchView, viewModel: movieSearchViewModel)
    }
    
    func makeMovieSearchResultViewController(textToSearch: String, delegate: CoordinatorDelegate?) -> MovieSearchResultViewController {
        
        let viewModel = MovieSearchResultViewModel(
            favoritesManager: movieSearchDomainFactory.makeFavoritesManagerProtocol(),
            movieSearchUseCase: movieSearchDomainFactory.makeMovieSearchUseCase(),
            movieImageDownloadUseCase: movieSearchDomainFactory.makeMovieImageDownloadUseCase(),
            query: textToSearch
        )
        
        viewModel.coordinatorDelegate = delegate
        return MovieSearchResultViewController(contentView: MoviesGridView(), viewModel: viewModel)
    }
}

//
//  MovieSearchResultViewModel.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import Foundation

final class MovieSearchResultViewModel: MovieSearchResultViewModelProtocol {

    var query: String
    weak var coordinatorDelegate: CoordinatorDelegate?
    weak var delegate: MovieSearchResultViewModelDelegate?
    
    private let favoritesManager: FavoritesManagerProtocol
    private let movieSearchUseCase: MovieSearchUseCaseProtocol
    private let movieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol
    
    private var movies: [Movie] = []
    private var totalPages: Int = 0
    private var page: Int = 0
    private var totalResults: Int = 0
    private let imageType: ImageType = .poster
    
    init(
        favoritesManager: FavoritesManagerProtocol,
        movieSearchUseCase: MovieSearchUseCaseProtocol,
        movieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol,
        query: String
    ) {
        self.favoritesManager = favoritesManager
        self.movieSearchUseCase = movieSearchUseCase
        self.movieImageDownloadUseCase = movieImageDownloadUseCase
        self.query = query
    }
    
    func fetchSearchMovies(query: String, page: Int?) {
        guard !query.isEmpty else {
            return
        }
        
        self.query = query
        
        movieSearchUseCase.execute(query: query, page: page, shouldIgnoreCache: true) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieSearch):
                self.totalPages = movieSearch.totalPages
                self.page = movieSearch.page
                self.totalResults = movieSearch.totalResults
                if let results = movieSearch.results {
                    self.movies.append(contentsOf: results)
                }
                self.delegate?.didReceiveMovies(self.movies, hasMorePages: self.page < self.totalPages)
            case .failure(let error):
                self.delegate?.didFailWithError(error.errorDescription)
            }
        }
    }
    
    func fetchNextPage() {
        guard page <= totalPages else {
            return
        }
        fetchSearchMovies(query: self.query, page: page + 1)
    }
    
    func fetchImageData(from url: String, shouldIgnoreCache: Bool, completion: @escaping (Data?) -> Void) {
        
        movieImageDownloadUseCase.getMovieImage(
            from: url,
            with: imageType,
            shouldIgnoreCache: shouldIgnoreCache) { result in
                switch result {
                case .success(let imageData):
                    completion(imageData)
                case .failure:
                    completion(nil)
                }
            }
    }
    
    func openMovieDetails(with movieId: Int, updateDelegate: MovieSearchResultViewControllerUpdateDelegate) {
        coordinatorDelegate?.showMovieDetailsViewController(with: movieId, updateDelegate: updateDelegate)
    }
    
    func manageFavoriteMovie(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void) {
        favoritesManager.manageFavoriteMovie(isFavorite: isFavorite, selectedMovie: selectedMovie, completion: completion)
    }
    
    func isFavoriteMovie(movie: Movie, completion: @escaping (Bool) -> Void) {
        favoritesManager.fetchFavoriteMovie(movieId: movie.id, completion: completion)
    }
}

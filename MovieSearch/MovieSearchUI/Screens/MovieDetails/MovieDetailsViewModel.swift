//
//  MovieDetailsViewModel.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import Foundation

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    weak var delegate: MovieDetailsViewModelDelegate?
    
    private let favoritesManager: FavoritesManagerProtocol
    private let movieDetailsUseCase: MovieDetailsUseCaseProtocol
    private let movieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol
    private let imageType: ImageType = .backdrop
    private let movieId: Int
    private var currentMovie: Movie?
    
    init(
        favoritesManager: FavoritesManagerProtocol,
        movieDetailsUseCase: MovieDetailsUseCaseProtocol,
        movieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol,
        movieId: Int
    ) {
        self.favoritesManager = favoritesManager
        self.movieDetailsUseCase = movieDetailsUseCase
        self.movieImageDownloadUseCase = movieImageDownloadUseCase
        self.movieId = movieId
    }
    
    func fetchMovieDetails() {
        movieDetailsUseCase.execute(id: movieId, shouldIgnoreCache: true) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieDetails):
                self.currentMovie = movieDetails
                self.delegate?.didFetch(movieDetails)
                if let backdropPath = movieDetails.backdropPath {
                    self.fetchImageData(from: backdropPath, shouldIgnoreCache: true) { imageData in
                        self.delegate?.didFetch(imageData)
                    }
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error.errorDescription)
            }
        }
    }
    
    func fetchImageData(from url: String, shouldIgnoreCache: Bool, completion: @escaping (Data?) -> Void) {
        movieImageDownloadUseCase.getMovieImage(from: url, with: imageType, shouldIgnoreCache: shouldIgnoreCache) { imageData in
            completion(imageData)
        }
    }
    
    func manageFavoriteMovie(isFavorite: Bool) {
        guard let currentMovie else { return }
        favoritesManager.manageFavoriteMovie(isFavorite: isFavorite, selectedMovie: currentMovie)
    }
    
    func isFavoriteMovie(completion: @escaping (Bool) -> Void) {
        favoritesManager.fetchFavoriteMovie(movieId: movieId, completion: completion)
    }
}

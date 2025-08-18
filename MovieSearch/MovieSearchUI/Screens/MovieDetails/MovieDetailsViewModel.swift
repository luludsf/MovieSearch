//
//  MovieDetailsViewModel.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import Foundation

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    weak var delegate: MovieDetailsViewModelDelegate?
    weak var updateDelegate: MovieSearchResultViewControllerUpdateDelegate?
    var title: String = UIStrings.Navigation.details
    
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
        movieDetailsUseCase.execute(id: movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movieDetails):
                self.currentMovie = movieDetails
                self.delegate?.didFetch(movieDetails)
                if let backdropPath = movieDetails.backdropPath {
                    self.fetchImageData(from: backdropPath) { imageData in
                        self.delegate?.didFetch(imageData)
                    }
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error.errorDescription)
            }
        }
    }
    
    func fetchImageData(from url: String, completion: @escaping (Data?) -> Void) {
        movieImageDownloadUseCase.getMovieImage(from: url, with: imageType) { result in
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func manageFavoriteMovie(isFavorite: Bool, completion: @escaping (Bool) -> Void) {
        guard let currentMovie else { return }
        favoritesManager.manageFavoriteMovie(isFavorite: isFavorite, selectedMovie: currentMovie) {[weak self] success in
            if success {
                self?.updateDelegate?.reloadView()
            }
        }
    }
    
    func isFavoriteMovie(completion: @escaping (Bool) -> Void) {
        favoritesManager.fetchFavoriteMovie(movieId: movieId, completion: completion)
    }
}

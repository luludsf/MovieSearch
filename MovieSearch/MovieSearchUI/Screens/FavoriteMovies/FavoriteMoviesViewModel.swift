//
//  FavoriteMoviesViewModel.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import Foundation

class FavoriteMoviesViewModel: FavoriteMoviesViewModelProtocol {

    weak var coordinatorDelegate: CoordinatorDelegate?
    private let favoritesManager: FavoritesManagerProtocol
    private let movieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol
    private let imageType: ImageType = .poster
    
    init(favoritesManager: FavoritesManagerProtocol,
        movieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol) {
        self.favoritesManager = favoritesManager
        self.movieImageDownloadUseCase = movieImageDownloadUseCase
    }
    
    func deleteFavoriteMovie(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        favoritesManager.deleteFavoriteMovie(movie, completion: completion)
    }
    
    func fetchAllFavoriteMovies(completion: @escaping ([Movie]?) -> Void) {
        favoritesManager.fetchAllFavoriteMovies(completion: completion)
    }
    
    func fetchFavoriteMovie(movieId: Int, completion: @escaping (Bool) -> Void) {
        favoritesManager.fetchFavoriteMovie(movieId: movieId, completion: completion)
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
    
    func openMovieDetails(with movieId: Int) {
        coordinatorDelegate?.showMovieDetailsViewController(with: movieId, updateDelegate: nil)
    }
}

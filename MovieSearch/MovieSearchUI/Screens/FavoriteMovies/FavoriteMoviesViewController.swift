//
//  FavoriteMoviesViewController.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    
    private let contentView: MoviesGridViewProtocol
    private var viewModel: FavoriteMoviesViewModelProtocol
    
    init(contentView: MoviesGridViewProtocol, viewModel: FavoriteMoviesViewModelProtocol) {
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.contentView.delegate = self
        self.contentView.messageLabelText = viewModel.emptyState
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
    }
    
    private func fetchFavoriteMovies() {
        self.contentView.updateState(.loading(true))
        viewModel.fetchAllFavoriteMovies { movies in
            guard let movies else {
                self.contentView.updateState(.loading(false))
                self.contentView.updateState(.error(self.viewModel.errorMessage))
                return
            }
            self.contentView.updateState(.loading(false))
            self.contentView.updateState(.success(movies, false))
        }
    }
}

extension FavoriteMoviesViewController: MoviesGridViewDelegate {

    func getImageData(from url: String, completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            self.viewModel.fetchImageData(
                from: url,
                completion: completion
            )
        }
    }
    
    func getFavorite(movie: Movie, completion: @escaping (Bool) -> Void) {
        viewModel.fetchFavoriteMovie(movieId: movie.id, completion: completion)
    }
    
    func didTapFavoriteButton(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void) {
        
        viewModel.deleteFavoriteMovie(selectedMovie) { [weak self] movieWasDeleted in
            if movieWasDeleted {
                self?.fetchFavoriteMovies()
            }
            completion(movieWasDeleted)
        }
    }
    
    func openMovieDetails(with movieId: Int) {
        viewModel.openMovieDetails(with: movieId)
    }
    
    
    func getNextPage() { }
}

//
//  MovieSearchResultViewController.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import UIKit

class MovieSearchResultViewController: UIViewController {
    
    private let contentView: MoviesGridViewProtocol
    private var viewModel: MovieSearchResultViewModelProtocol
    
    init(contentView: MoviesGridViewProtocol,
        viewModel: MovieSearchResultViewModelProtocol) {
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.contentView.delegate = self
    }
    
    override func loadView() {
        view = contentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(viewModel.query)"
        fetch()
    }
    
    private func fetch() {
        self.contentView.updateState(.loading(true))
        viewModel.fetchSearchMovies(query: viewModel.query, page: nil)
    }
}

extension MovieSearchResultViewController: MovieSearchResultViewModelDelegate {
    func didReceiveMovies(_ movies: [Movie], hasMorePages: Bool) {
        self.contentView.updateState(.loading(false))
        DispatchQueue.main.async { [weak self] in
            self?.contentView.updateState(.success(movies, hasMorePages))
        }
    }
    
    func didFailWithError(_ message: String) {
        self.contentView.updateState(.loading(false))
        self.contentView.updateState(.error(message))
    }
}

extension MovieSearchResultViewController: MoviesGridViewDelegate {
    func fetchMovies() {
        self.contentView.updateState(.loading(true))
        viewModel.fetchSearchMovies(query: viewModel.query, page: nil)
    }
    
    func didTapFavoriteButton(isFavorite: Bool, selectedMovie: Movie, completion: @escaping (Bool) -> Void) {
        viewModel.manageFavoriteMovie(isFavorite: isFavorite, selectedMovie: selectedMovie, completion: completion)
    }
    
    func getFavorite(movie: Movie, completion: @escaping (Bool) -> Void) {
        viewModel.isFavoriteMovie(movie: movie, completion: completion)
    }
    
    func getImageData(from url: String, shouldIgnoreCache: Bool, completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            self.viewModel.fetchImageData(from: url, shouldIgnoreCache: shouldIgnoreCache) { imageData in
                completion(imageData)
            }
        }
    }
    
    func getNextPage() {
        viewModel.fetchNextPage()
    }
    
    func openMovieDetails(with movieId: Int) {
        viewModel.openMovieDetails(with: movieId, updateDelegate: self)
    }
}

extension MovieSearchResultViewController: MovieSearchResultViewControllerUpdateDelegate {
    func reloadView() {
        fetch()
    }
}

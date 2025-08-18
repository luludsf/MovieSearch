//
//  MovieDetailsViewController.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

// TODO: ADICIONAR ESTADOS DE LOADING, SUCESSO OU ERRO

final class MovieDetailsViewController: UIViewController {
    
    private let contentView: MovieDetailViewProtocol
    private var viewModel: MovieDetailsViewModelProtocol
    
    init(contentView: MovieDetailViewProtocol,
        viewModel: MovieDetailsViewModelProtocol) {
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
        title = "Detalhes"
        viewModel.fetchMovieDetails()
    }
}

extension MovieDetailsViewController: MovieDetailsViewModelDelegate {
    func didFetch(_ imageData: Data?) {
        DispatchQueue.main.async {
            self.contentView.updateImage(with: imageData)
        }
    }
    
    func didFetch(_ movie: Movie) {
        DispatchQueue.main.async {
            self.viewModel.isFavoriteMovie { isFavorite in
                self.contentView.configure(with: movie, isFavorite: isFavorite)
            }
        }
    }
    
    func didFailWithError(_ error: String) {
        DispatchQueue.main.async {
            self.contentView.showError(message: error)
        }
    }
}

extension MovieDetailsViewController: MovieDetailViewDelegate {
    func didTapFavoriteButton(isFavorite: Bool, completion: @escaping (Bool) -> Void) {
        viewModel.manageFavoriteMovie(isFavorite: isFavorite, completion: completion)
    }
}

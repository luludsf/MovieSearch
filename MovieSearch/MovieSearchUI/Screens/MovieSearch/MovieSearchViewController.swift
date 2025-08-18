//
//  MovieSearchViewController.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

class MovieSearchViewController: UIViewController {
        
    private var searchView: MovieSearchViewProtocol
    private var viewModel: MovieSearchViewModelProtocol
    
    init(searchView: MovieSearchViewProtocol,
        viewModel: MovieSearchViewModelProtocol) {
        self.searchView = searchView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.searchView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Busca"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MovieSearchViewController: MovieSearchViewDelegate {
    func didTapSearchButton(with text: String) {
        viewModel.openMovieResults(for: text)
    }
}

//
//  MoviesGridViewController.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import UIKit

enum MovieViewState {
    case success([Movie], Bool)
    case error(String)
    case loading(Bool)
}

class MoviesGridView: UIView, MoviesGridViewProtocol {
    
    weak var delegate: MoviesGridViewDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .extraLargeTitle)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var messageLabelText: String?
    private var movies: [Movie] = []
    private var hasMorePages = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        addSubview(messageLabel)
        addSubview(activityIndicatorView)
        backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func updateState(_ state: MovieViewState) {
        DispatchQueue.main.async {
            switch state {
            case .success(let movies, let hasMorePages):
                self.setEmptyState(isEmpty: movies.isEmpty)
                self.movies = movies
                self.hasMorePages = hasMorePages
                self.collectionView.reloadData()
            case .error(let message):
                self.messageLabel.text = message
                self.messageLabel.isHidden = false
            case .loading(let shouldLoad):
                self.messageLabel.isHidden = true
                if shouldLoad {
                    self.activityIndicatorView.isHidden = false
                    self.activityIndicatorView.startAnimating()
                } else {
                    self.activityIndicatorView.isHidden = true
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    func setEmptyState(isEmpty: Bool) {
        messageLabel.text = messageLabelText
        collectionView.isHidden = isEmpty
        messageLabel.isHidden = !isEmpty
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesGridView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            fatalError("Não foi possível efetuar o dequeueReusableCell com o MovieCell.reuseIdentifier")
        }
        
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        delegate?.getFavorite(movie: movie) { isFavorite in
            cell.updateFavoriteState(isFavorite: isFavorite)
        }
        
        cell.didTapFavoriteButton = { [weak self] isFavorite in
            self?.delegate?.didTapFavoriteButton(isFavorite: isFavorite, selectedMovie: movie) { movieWasDeleted in
                cell.enableUserInteraction()
                if !movieWasDeleted {
                    cell.toggleFavoriteButton()
                }
            }
        }
        
        if let imageURL = movie.posterPath {
            delegate?.getImageData(from: imageURL, shouldIgnoreCache: false) { imageData in
                DispatchQueue.main.async() {
                    if let imageData,
                       let image = UIImage(data: imageData),
                       let cellToUpdate = collectionView.cellForItem(at: indexPath) as? MovieCell {
                        cellToUpdate.updateImage(with: image)
                    }
                }
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesGridView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        delegate?.openMovieDetails(with: movie.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 && hasMorePages {
            delegate?.getNextPage()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - (8 * 2) - 8
        return CGSize(width: width/2, height: width)
    }
}

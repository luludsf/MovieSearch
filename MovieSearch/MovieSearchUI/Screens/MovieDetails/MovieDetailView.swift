//
//  MovieDetailView.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

class MovieDetailView: UIView, MovieDetailViewProtocol {
    
    enum MovieDetailViewState {
        case loading
        case success(Movie, Bool)
        case error(String)
    }

    weak var delegate: MovieDetailViewDelegate?
            
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: UIStrings.Icons.movieClapper)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel = UILabel.createLabel(font: .systemFont(ofSize: 28, weight: .bold), color: .black)
    let originalTitleLabel = UILabel.createLabel(font: .systemFont(ofSize: 18, weight: .regular), color: .black)
    let ratingLabel = UILabel.createLabel(font: .systemFont(ofSize: 18, weight: .semibold), color: .black)
    let overviewLabel = UILabel.createLabel(font: .systemFont(ofSize: 16, weight: .regular), color: .black)
    let releaseDateLabel = UILabel.createLabel(font: .systemFont(ofSize: 16, weight: .regular), color: .black)
    let budgetLabel = UILabel.createLabel(font: .systemFont(ofSize: 16, weight: .regular), color: .black)
    let revenueLabel = UILabel.createLabel(font: .systemFont(ofSize: 16, weight: .regular), color: .black)

    let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: UIStrings.Icons.heart), for: .normal)
        button.setImage(UIImage(systemName: UIStrings.Icons.heartFilled), for: .selected)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .extraLargeTitle)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupStateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    private func setupLayout() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        addSubview(backdropImageView)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(favoriteButton)
        contentStackView.addArrangedSubview(titleStackView)
        contentStackView.addArrangedSubview(originalTitleLabel)
        contentStackView.addArrangedSubview(ratingLabel)
        contentStackView.addArrangedSubview(overviewLabel)
        contentStackView.addArrangedSubview(releaseDateLabel)
        contentStackView.addArrangedSubview(budgetLabel)
        contentStackView.addArrangedSubview(revenueLabel)
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            backdropImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }
    
    private func setupStateViews() {
        addSubview(loadingView)
        addSubview(errorView)
        errorView.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            errorMessageLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor, constant: -20),
            errorMessageLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapFavoriteButton() {
        favoriteButton.isSelected.toggle()
        delegate?.didTapFavoriteButton(isFavorite: favoriteButton.isSelected) { success in
            if !success {
                self.favoriteButton.isSelected.toggle()
            }
        }
    }
        
    func updateState(_ state: MovieDetailViewState) {
        DispatchQueue.main.async {
            self.scrollView.isHidden = true
            self.backdropImageView.isHidden = true
            self.loadingView.stopAnimating()
            self.errorView.isHidden = true

            switch state {
            case .loading:
                self.loadingView.startAnimating()
            case .success(let movie, let isFavorite):
                self.configure(with: movie, isFavorite: isFavorite)
                self.scrollView.isHidden = false
                self.backdropImageView.isHidden = false
            case .error(let message):
                self.errorMessageLabel.text = message
                self.errorView.isHidden = false
            }
        }
    }

    private func configure(with movie: Movie, isFavorite: Bool) {
        titleLabel.text = movie.title
        originalTitleLabel.text = String(format: UIStrings.Movie.original, movie.originalTitle ?? UIStrings.Common.na)
        ratingLabel.text = String(format: UIStrings.Movie.rating, movie.voteAverage)
        overviewLabel.text = movie.overview
        releaseDateLabel.text = String(format: UIStrings.Movie.release, movie.releaseDate ?? UIStrings.Common.na)
        budgetLabel.text = String(format: UIStrings.Movie.budget, formatAsCurrency(String(movie.budget ?? 0)))
        revenueLabel.text = String(format: UIStrings.Movie.revenue, formatAsCurrency(String(movie.revenue ?? 0)))
        favoriteButton.isSelected = isFavorite
    }
    
    func updateImage(with data: Data?) {
        if let data {
            backdropImageView.image = UIImage(data: data)
            backdropImageView.contentMode = .scaleAspectFill
        }
    }
    
    private func formatAsCurrency(_ string: String?) -> String {
        guard let string = string, let value = Int(string) else { return UIStrings.Common.na }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = UIStrings.Common.usd
        formatter.currencySymbol = UIStrings.Common.dollarSymbol
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? UIStrings.Common.na
    }
}

extension UILabel {
    static func createLabel(font: UIFont, color: UIColor, lines: Int = 0) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.numberOfLines = lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

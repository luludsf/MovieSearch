//
//  MovieDetailView.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

class MovieDetailView: UIView, MovieDetailViewProtocol {

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
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        imageView.image = UIImage(systemName: "movieclapper")
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
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "suit.heart.fill"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        addSubview(backdropImageView)
        //addSubview(contentStackView)
        
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
    
    @objc private func didTapFavoriteButton() {
        favoriteButton.isSelected.toggle()
        delegate?.didTapFavoriteButton(isFavorite: favoriteButton.isSelected)
    }
    
    // MARK: - Configuração da View com o Modelo
    
    func configure(with movie: Movie, isFavorite: Bool) {
        titleLabel.text = movie.title
        originalTitleLabel.text = "Original: \(movie.originalTitle ?? "N/A")"
        ratingLabel.text = "★ \(String(format: "%.1f", movie.voteAverage))"
        overviewLabel.text = movie.overview
        releaseDateLabel.text = "Lançamento: \(movie.releaseDate ?? "N/A")"
        budgetLabel.text = "Custo: \(formatAsCurrency(String(movie.budget ?? 0)))"
        revenueLabel.text = "Arrecadação: \(formatAsCurrency(String(movie.revenue ?? 0)))"
        favoriteButton.isSelected = isFavorite
    }
    
    func updateImage(with data: Data?) {
        if let data {
            backdropImageView.image = UIImage(data: data)
            backdropImageView.contentMode = .scaleAspectFill
        }
    }
    
    private func formatAsCurrency(_ string: String?) -> String {
        guard let string = string, let value = Int(string) else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "N/A"
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

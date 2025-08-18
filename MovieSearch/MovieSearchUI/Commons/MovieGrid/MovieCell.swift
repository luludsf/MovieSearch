//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCell"
    
    var didTapFavoriteButton: ((Bool) -> Void)?
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.backgroundColor = .systemYellow
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(systemName: "movieclapper")
        updateImageViewAppearance(isPlaceholder: true)
        titleLabel.text = nil
        ratingLabel.text = nil
    }
    
    private func setupViews() {
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(favoriteButton)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleStackView)
        
        contentView.addSubview(stackView)
        contentView.addSubview(ratingLabel)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        
        addShadow()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            ratingLabel.widthAnchor.constraint(equalToConstant: 30),
            ratingLabel.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        favoriteButton.addTarget(self, action: #selector(didTapFavButton), for: .touchUpInside)
    }
    
    @objc private func didTapFavButton() {
        favoriteButton.isSelected.toggle()
        isUserInteractionEnabled = false
        didTapFavoriteButton?(favoriteButton.isSelected)
    }
    
    func enableUserInteraction() {
        isUserInteractionEnabled = true
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.originalTitle
        ratingLabel.text = "\(String(format: "%.1f", movie.voteAverage))"
        imageView.image = UIImage(systemName: "movieclapper")
        updateImageViewAppearance(isPlaceholder: true)
        
    }
    
    func toggleFavoriteButton() {
        favoriteButton.isSelected.toggle()
    }
    
    func updateFavoriteState(isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
    }
    
    func updateImage(with image: UIImage) {
        imageView.image = image
        updateImageViewAppearance(isPlaceholder: false)
    }
    
    private func updateImageViewAppearance(isPlaceholder: Bool) {
        imageView.contentMode = isPlaceholder ? .center : .scaleAspectFill
    }
    
    private func addShadow() {
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowColor = UIColor.black.cgColor
    }
}

//
//  MovieSearchView.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

class MovieSearchView: UIView, MovieSearchViewProtocol {
    
    weak var delegate: MovieSearchViewDelegate?
        
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite o nome do filme que está buscando..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buscar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(searchStackView)
        
        searchButton.setTitleColor(.lightGray, for: .disabled)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
        
        searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc
    private func didTapSearchButton() {
        guard let text = searchTextField.text, !text.isEmpty else { return }
        delegate?.didTapSearchButton(with: searchTextField.text ?? "")
    }
    
    @objc private func textDidChange() {
        let textWithoutWhitespacesAndNewlines = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let isTextValid = !(textWithoutWhitespacesAndNewlines?.isEmpty ?? true)
        searchButton.isEnabled = isTextValid
    }
}

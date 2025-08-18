//
//  MoviesGridViewProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 16/08/25.
//

import UIKit

protocol MoviesGridViewProtocol: UIView {
    var delegate: MoviesGridViewDelegate? { get set }
    var messageLabelText: String? { get set }
    func updateState(_ state: MovieViewState)
}

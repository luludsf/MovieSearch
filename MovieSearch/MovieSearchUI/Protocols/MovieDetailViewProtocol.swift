//
//  MovieDetailViewProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit
import Foundation

protocol MovieDetailViewProtocol: UIView {
    var delegate: MovieDetailViewDelegate? { get set }
    
    func updateImage(with data: Data?)
    func configure(with movie: Movie, isFavorite: Bool)
}

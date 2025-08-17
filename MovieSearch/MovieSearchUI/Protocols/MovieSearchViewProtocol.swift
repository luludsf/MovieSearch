//
//  MovieSearchViewProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import UIKit

protocol MovieSearchViewProtocol: UIView {
    var delegate: MovieSearchViewDelegate? { get set }
}

//
//  MovieDetailsViewModelDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import Foundation

protocol MovieDetailsViewModelDelegate: AnyObject {
    func didFetch(_ movie: Movie)
    func didFetch(_ imageData: Data?)
    func didFailWithError(_ error: String)
}

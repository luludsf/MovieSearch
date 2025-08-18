//
//  MovieDetailsViewModelProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var delegate: MovieDetailsViewModelDelegate? { get set }
    var updateDelegate: MovieSearchResultViewControllerUpdateDelegate? { get set }
    var title: String { get }
    
    func fetchMovieDetails()
    func fetchImageData(from url: String, completion: @escaping (Data?) -> Void)
    func manageFavoriteMovie(isFavorite: Bool, completion: @escaping (Bool) -> Void)
    func isFavoriteMovie(completion: @escaping (Bool) -> Void)
}

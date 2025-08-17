//
//  MovieDetailsViewModelProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 17/08/25.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var delegate: MovieDetailsViewModelDelegate? { get set }
    
    func fetchMovieDetails()
    func fetchImageData(from url: String, shouldIgnoreCache: Bool, completion: @escaping (Data?) -> Void)
    func manageFavoriteMovie(isFavorite: Bool)
    func isFavoriteMovie(completion: @escaping (Bool) -> Void)
}

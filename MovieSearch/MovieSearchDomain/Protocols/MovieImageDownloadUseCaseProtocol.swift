//
//  MovieImageDownloadUseCaseProtocol.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import Foundation

protocol MovieImageDownloadUseCaseProtocol {
    func getMovieImage(
        from url: String,
        with imageType: ImageType,
        completion: @escaping (Result<Data?, MovieSearchError>) -> Void
    )
}

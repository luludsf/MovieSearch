//
//  MovieImageDownloadUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import Foundation

class MovieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol {
    
    private let repository: MovieSearchRepositoryProtocol
    
    init(repository: MovieSearchRepositoryProtocol) {
        self.repository = repository
    }
    
    func getMovieImage(from url: String, with imageType: ImageType, shouldIgnoreCache: Bool, completion: @escaping (Result<Data?, MovieSearchError>) -> Void) {
        
        repository.getMovieImage(
            from: url,
            with: imageType,
            shouldIgnoreCache: shouldIgnoreCache,
            completion: completion
        )
    }
}

//
//  MockCoordinatorDelegate.swift
//  MovieSearch
//
//  Created by Luana Duarte on 18/08/25.
//

import Foundation
@testable import MovieSearch

class MockMovieImageDownloadUseCase: MovieImageDownloadUseCaseProtocol {
    
    var shouldSucceed = true
    var mockImageData: Data?
    var lastURL: String?
    var lastImageType: ImageType?
    
    func getMovieImage(from url: String, with imageType: ImageType, completion: @escaping (Result<Data?, MovieSearchError>) -> Void) {
        self.lastURL = url
        self.lastImageType = imageType
        
        if shouldSucceed, let mockImageData = mockImageData {
            completion(.success(mockImageData))
        } else {
            completion(.failure(.unexpected))
        }
    }
}

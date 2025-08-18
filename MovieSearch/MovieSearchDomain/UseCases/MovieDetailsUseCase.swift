//
//  MovieDetailsUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class MovieDetailsUseCase: MovieDetailsUseCaseProtocol {
    
    private let repository: MovieSearchRepositoryProtocol
    
    init(repository: MovieSearchRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int, completion: @escaping (Result<Movie, MovieSearchError>) -> Void) {
        repository.getMovieDetails(with: id) { (result: Result<Movie, MovieSearchError>) in
            switch result {
            case .success(let movieDetails):
                completion(.success(movieDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

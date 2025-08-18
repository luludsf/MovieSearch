//
//  MovieSearchUseCase.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

class MovieSearchUseCase: MovieSearchUseCaseProtocol {
    
    private let repository: MovieSearchRepositoryProtocol
    
    init(repository: MovieSearchRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int?, completion: @escaping (Result<MovieSearch, MovieSearchError>) -> Void) {
        repository.getSearch(from: query, page: page) { (result: Result<MovieSearch, MovieSearchError>) in
            switch result {
            case .success(let search):
                completion(.success(search))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

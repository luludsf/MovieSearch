//
//  MovieSearchRepository.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import Foundation

final class MovieSearchRepository: MovieSearchRepositoryProtocol {

    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getSearch(from query: String, page: Int?, completion: @escaping (Result<MovieSearch, MovieSearchError>) -> Void) {
        let request: MovieSearchRequest = .movieSearch(query: query, page: page)
        
        networking.perform(request) { (result: Result<MovieSearchRespone, NetworkingError>) in
            switch result {
            case .success(let movieSearchRespone):
                let moviesResponses = movieSearchRespone.results?.map {
                    Movie(
                        id: $0.id,
                        originalTitle: $0.originalTitle,
                        posterPath: $0.posterPath,
                        voteAverage: $0.voteAverage,
                        backdropPath: $0.backdropPath,
                        title: $0.title,
                        overview: $0.overview,
                        releaseDate: $0.releaseDate,
                        budget: $0.budget,
                        revenue: $0.revenue
                    )
                }
                let movieSearch = MovieSearch(results: moviesResponses, page: movieSearchRespone.page, totalPages: movieSearchRespone.totalPages, totalResults: movieSearchRespone.totalResults)
                completion(.success(movieSearch))
                
            case .failure(let error):
                let serviceError = self.mapNetworking(error)
                completion(.failure(serviceError))
            }
        }
    }
    
    func getMovieDetails(with id: Int, completion: @escaping (Result<Movie, MovieSearchError>) -> Void) {
        let request: MovieSearchRequest = .movieDetails(id: id)
        
        networking.perform(request) { (result: Result<MovieResponse, NetworkingError>) in
            switch result {
            case .success(let movieDetailsResponse):
                let movieDetails = Movie(
                    id: movieDetailsResponse.id,
                    originalTitle: movieDetailsResponse.originalTitle,
                    posterPath: movieDetailsResponse.posterPath,
                    voteAverage: movieDetailsResponse.voteAverage,
                    backdropPath: movieDetailsResponse.backdropPath,
                    title: movieDetailsResponse.title,
                    overview: movieDetailsResponse.overview,
                    releaseDate: movieDetailsResponse.releaseDate,
                    budget: movieDetailsResponse.budget,
                    revenue: movieDetailsResponse.revenue
                )
                completion(.success(movieDetails))
            case .failure(let error):
                let serviceError = self.mapNetworking(error)
                completion(.failure(serviceError))
            }
        }
    }
    
    func getMovieImage(from url: String, with imageType: ImageType, completion: @escaping (Result<Data?, MovieSearchError>) -> Void) {
        let request: MovieImageDownloadRequest = .movieImageDownload(url, imageType)
        
        networking.perform(request) { (result: Result<Data, NetworkingError>) in
            switch result {
            case.success(let imageData):
                completion(.success(imageData))
            case .failure(let error):
                let serviceError = self.mapNetworking(error)
                completion(.failure(serviceError))
            }
        }
    }
    
    private func mapNetworking(_ error: NetworkingError) -> MovieSearchError {
        switch error {
        case .httpError, .noInternetConnection, .timeout:
            return .serviceUnavailable
            
        case .requestFailed, .invalidURL, .invalidResponse,
                .invalidResponseData, .invalidBodyData, .cancelled, .decodingFailed:
            return .unexpected
        }
    }
}

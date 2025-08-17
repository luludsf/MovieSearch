//
//  MovieSearchDomainError.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

enum MovieSearchError: Error {
    case serviceUnavailable
    case unexpected
    
    var errorDescription: String {
        switch self {
        case .serviceUnavailable:
            return "Serviço indisponível"
        case .unexpected:
            return "Houve um erro inesperado"
        }
    }
}

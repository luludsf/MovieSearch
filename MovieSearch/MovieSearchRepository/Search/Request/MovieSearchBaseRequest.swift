//
//  MovieSearchBaseRequest.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

protocol MovieSearchBaseRequest: Request { }

extension MovieSearchBaseRequest {
    
    var host: String {
        "api.themoviedb.org"
    }
    
    var scheme: String {
        "https"
    }
    
    var version: String {
        "3"
    }
    
    var path: String { "" }

    var method: HTTPMethod { .GET }
    
    var headers: [String: String]? { nil }
    
    var bodyParams: [String: Any?]? { nil }
    
    var queryParams: [String: String]? { nil }
}

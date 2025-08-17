//
//  MovieSearchRequest.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

import Foundation

enum MovieSearchRequest {
    
    case movieSearch(query: String, page: Int?)
    case movieDetails(id: Int)
    
    var host: String {
        "api.themoviedb.org"
    }
    
    var scheme: String {
        "https"
    }
    
    var version: String {
        "3"
    }
    
    var method: HTTPMethod { .GET }
    
    var path: String {
        switch self {
        case .movieDetails(let id):
            return "/\(version)/movie/\(id)"
        case .movieSearch:
            return "/\(version)/search/movie"
        }
    }
    
    var queryParams: [String : String]? {
        var params: [String: String] = ["language": "pt-BR", "api_key": AppConfig.apiKey]
        switch self {
        case .movieSearch(let query, let page):
            params["query"] = query
            if let page {
                params["page"] = String(page)
            }
            return params
        default:
            return params
        }
    }
}

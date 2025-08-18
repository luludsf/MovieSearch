//
//  MovieImageDownloadRequest.swift
//  MovieSearch
//
//  Created by Luana Duarte on 15/08/25.
//

enum MovieImageDownloadRequest: Request {

    case movieImageDownload(String, ImageType)
    
    var host: String {
        "image.tmdb.org"
    }
    
    var scheme: String {
        "https"
    }
    
    var version: String { "" }
    
    var path: String {
        if case .movieImageDownload(let string, let imageType) = self {
            return "/t/p/\(imageType.rawValue)\(string)"
        }
        return ""
    }
    
    var method: HTTPMethod { .GET }
    
    var headers: [String : String]? {
        nil
    }
    
    var bodyParams: [String : Any?]? { nil }
    
    var queryParams: [String : String]? { nil }
}

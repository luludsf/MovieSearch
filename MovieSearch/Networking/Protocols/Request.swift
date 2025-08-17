//
//  Endpoint.swift
//  MovieSearch
//
//  Created by Luana Duarte on 14/08/25.
//

protocol Request {
    var host: String { get }
    
    var scheme: String { get }
    
    var version: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String]? { get }
    
    var bodyParams: [String: Any?]? { get }
    
    var queryParams: [String: String]? { get }
}

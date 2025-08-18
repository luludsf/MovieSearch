//
//  Networking.swift
//  MovieSearch
//
//  Created by Luana Duarte on 14/08/25.
//

import Foundation

protocol Networking {
    
    func perform<T: Codable>(
        _ request: Request,
        completion: @escaping (Result<T, NetworkingError>
        ) -> Void)
    
    func perform(
        _ request: Request,
        completion: @escaping (Result<Data, NetworkingError>) -> Void
    )
}

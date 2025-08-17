//
//  AppConfig.swift
//  MovieSearch
//
//  Created by Luana Duarte on 14/08/25.
//

import Foundation

struct AppConfig {
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist file not found.")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = AppConfig.infoDictionary["API_KEY"] as? String else {
            fatalError("API_KEY not set in Info.plist for this configuration.")
        }
        return apiKeyString
    }()
}

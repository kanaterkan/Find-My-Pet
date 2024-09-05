//
//  AppConfig.swift
//  FindMyPet
//
//  Created by Berkay Aksu on 12.12.23.
//

import Foundation

struct AppConfig {
    static var baseURL: String {
        guard let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path),
            let baseURL = config["BaseURL"] as? String
            else {
                fatalError("Unable to load AppConfig.plist")
        }
        return baseURL
    }
}


//
//  ConfigManager.swift
//  SmartHomeApp
//
//  Created by Nguyen Van Thanh on 27/4/25.
//

import Foundation

class ConfigManager {
    static let shared = ConfigManager()
    
    private var config: [String: Any]?
    
    private init() {
        loadConfig()
    }
    
    private func loadConfig() {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url) {
            config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
        }
        print(config)
    }
    
    var isAuthenticationRequired: Bool {
        return config?["AuthenticationRequired"] as? Bool ?? true // Default to true if not set
    }
    
    var appTestId: String {
        return config?["AppTestId"] as? String ?? "sKRHXxHf9cgzna8ce9UMdFvHZVZ2" // Example mock ID or default
    }
}

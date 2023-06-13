//
//  EnvironmentService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 20.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import Foundation

enum Environment: String {
    case debug
    case release
}

final class EnvironmentService {
    private enum Constants {
        static let buildConfigurationNameKey = "BUILD_CONFIGURATION_NAME"
    }
    
    static let shared = EnvironmentService()
    
    private(set) lazy var currentEnvironment = getCurrentEnvironment()
    
    private init() {}
    
    private func getCurrentEnvironment() -> Environment {
        guard
            let instance = Bundle.main.object(forInfoDictionaryKey: Constants.buildConfigurationNameKey) as? String,
            let environment = Environment(rawValue: instance)
        else {
            return .debug
        }
        
        return environment
    }
}

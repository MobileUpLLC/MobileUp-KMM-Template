//
//  EnvironmentService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 20.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation

enum Environment: String {
    case debug
    case release
}

final class EnvironmentService {
    private enum Constants {
        static let instanceKey = "INSTANCE"
    }
    
    static let shared = EnvironmentService()
    
    private(set) lazy var currentEnvironment = getCurrentEnvironment()
    
    private init() {}
    
    private func getCurrentEnvironment() -> Environment {
        guard
            let instance = Bundle.main.object(forInfoDictionaryKey: Constants.instanceKey) as? String,
            let environment = Environment(rawValue: instance)
        else {
            return .debug
        }
        
        return environment
    }
}

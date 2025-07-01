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
    
    var isRelease: Bool { self == .release }
}

final class EnvironmentService: Sendable {
    enum ConfigKey: String, CaseIterable {
        case buildConfigurationNameKey = "BUILD_CONFIGURATION_NAME"
        case urlSchemeKey = "URL_SCHEME"
        case urlNameKey = "URL_NAME"
        
        var key: String { rawValue }
    }
    
    static let shared = EnvironmentService()
    static var urlScheme: String { value(for: .urlSchemeKey)! }
    static var urlName: String { value(for: .urlNameKey)! }
    
    let currentEnvironment: Environment
    var isRelease: Bool { currentEnvironment.isRelease }
    
    private init() {
        self.currentEnvironment = EnvironmentService.getCurrentEnvironment()
    }
    
    static func getCurrentEnvironment() -> Environment {
        guard
            let instance = Bundle.main.object(forInfoDictionaryKey: ConfigKey.buildConfigurationNameKey.key) as? String,
            let environment = Environment(rawValue: instance)
        else {
            return .debug
        }
        
        return environment
    }
    
    static private func value<T: LosslessStringConvertible>(for key: ConfigKey) -> T? {
        return try? EnvironmentsConfiguration.value(for: key.rawValue)
    }
}

enum EnvironmentsConfiguration {
    enum Error: Swift.Error {
        case missingKey
        case invalidValue
        case missingValue
    }
    
    static func value<T: LosslessStringConvertible>(for key: String) throws -> T {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        guard let string = object as? String, string.isEmpty == false else {
            throw Error.missingValue
        }
        guard let value = T(string) else {
            throw Error.invalidValue
        }
        
        return value
    }
    
    static func checkValue(for key: String) {
        do {
            let stringValue: String = try value(for: key)
            Log.environments.debug(logEntry: .detailed(
                text: "Key was found successfully",
                parameters: [key: stringValue])
            )
        } catch EnvironmentsConfiguration.Error.missingKey {
            Log.environments.debug(logEntry: .text("Missing key: \(key). Add missing key to Info.plist file"))
        } catch EnvironmentsConfiguration.Error.missingValue {
            Log.environments.debug(logEntry: .text("Missing value for key: \(key)"))
        } catch EnvironmentsConfiguration.Error.invalidValue {
            Log.environments.debug(logEntry: .text("Invalid value for key: \(key)"))
        } catch {
            Log.environments.debug(logEntry: .text("Undefined error for key: \(key)"))
        }
    }
}

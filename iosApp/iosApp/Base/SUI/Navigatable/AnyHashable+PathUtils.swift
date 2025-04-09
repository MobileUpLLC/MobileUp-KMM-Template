//
//  AnyHashable+PathUtils.swift
//  iosApp
//
//  Created by Denis Dmitriev on 07.04.2025.
//

import Foundation

extension AnyHashable {
    public func cast<T: Hashable>(to type: T.Type) -> T? {
        return self as? T
    }
    
    public func pathDescription(count: Int = 1) -> String {
        guard let classPart = self.description.components(separatedBy: "@").first else {
            return "Empty destination"
        }
        
        let destination: String = classPart.components(separatedBy: ".")
            .suffix(count)
            .joined(separator: ".")
        
        return destination
    }
}

extension Array where Element == AnyHashable {
    public func pathDescription(count: Int = 1) -> String {
        var result: [String] = []
        
        for element in self {
            result.append(element.pathDescription(count: count))
        }
        
        return result.joined(separator: " -> ")
    }
}

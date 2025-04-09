//
//  NavigationPath+State.swift
//  iosApp
//
//  Created by Denis Dmitriev on 08.04.2025.
//

import SwiftUI

extension NavigationPath {
    enum State {
        case push
        case pop
        case popToRoot
        case empty
    }
    
    func getState(fromPath: [AnyHashable]) -> State {
        let fromPath = fromPath.dropFirst() // Удаляем базовый компонент, так как в SwiftUI path не содержит базовый элемент
        if self.count - fromPath.count == 1 {
            return .push
        } else if fromPath.count - self.count == 1 {
            return .pop
        } else if self.count == 0 {
            return .popToRoot
        } else {
            return .empty
        }
    }
}

extension NavigationPath {
    mutating func removeAll() {
        self.removeLast(self.count)
    }
}

extension NavigationPath {
    var pathDescription: String {
        let mirror = Mirror(reflecting: self)

        var result: [String] = []

        for child in mirror.children {
            if let label = child.label, label == "_items" {
                let itemsMirror = Mirror(reflecting: child.value)
                for itemChild in itemsMirror.children {
                    let itemMirror = Mirror(reflecting: itemChild.value)
                    for element in itemMirror.children {
                        let typeDescription = String(describing: type(of: element.value))
                        if let typeName = extractTypeName(from: typeDescription) {
                            result.append(typeName)
                        }
                    }
                }
            }
        }

        if result.isEmpty {
            return "NavigationPath is empty"
        } else {
            return result.joined(separator: " -> ")
        }
    }
    
    private func extractTypeName(from input: String) -> String? {
        let pattern = #"ItemBox<([^>]+)>"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: input, range: NSRange(input.startIndex..., in: input)),
           let range = Range(match.range(at: 1), in: input) {
            return String(input[range])
        }
        return nil
    }
}

//
//  NavigationState.swift
//  iosApp
//
//  Created by Denis Dmitriev on 07.04.2025.
//

import Foundation

enum NavigationState: CustomStringConvertible {
    case root(AnyHashable)
    case push(AnyHashable)
    case pop
    case popToRoot
    case empty
    case replace([AnyHashable])
    
    var description: String {
        switch self {
        case .root(let root):
            return "🏁 \(root.pathDescription())"
        case .push(let item):
            return "▶️ \(item.pathDescription())"
        case .pop:
            return "◀️"
        case .popToRoot:
            return "⏮️"
        case .empty:
            return "⁉️"
        case .replace:
            return "🔄"
        }
    }
}

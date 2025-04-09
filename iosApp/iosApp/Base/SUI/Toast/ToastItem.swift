//
//  ToastItem.swift
//  Barcelona
//
//  Created by Denis Dmitriev on 10.03.2025.
//

import SwiftUI

enum ToastItem: Hashable {
    case info(title: String?, text: String, image: Image? = nil, onAction: Closure.Void?)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .info(title, text, image, onAction):
            hasher.combine(title)
            hasher.combine(text)
        }
    }
    
    static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
        switch (lhs, rhs) {
        case (.info(let lhsTitle, let lhsText, _, _), .info(let rhsTitle, let rhsText, _, _)):
            return lhsTitle == rhsTitle && lhsText == rhsText
        }
    }
}

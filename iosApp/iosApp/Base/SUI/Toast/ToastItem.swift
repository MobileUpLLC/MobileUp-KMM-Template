//
//  ToastItem.swift
//  Barcelona
//
//  Created by Denis Dmitriev on 10.03.2025.
//

import SwiftUI

struct ToastItem: Hashable {
    enum ToastType: Hashable {
        case info, error, success
    }
    
    var text: String
    var actionTitle: String?
    var onAction: (() -> Void)?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(actionTitle)
    }
    
    static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
        return lhs.text == rhs.text
        && lhs.actionTitle == rhs.actionTitle
        && (lhs.onAction == nil && rhs.onAction == nil)
    }
}

extension ToastItem {
    init(message: Message) {
        self.text = message.text.localized()
        self.actionTitle = message.actionTitle?.localized()
        self.onAction = message.action
    }
}

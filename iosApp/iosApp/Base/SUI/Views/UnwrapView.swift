//
//  UnwrapView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

struct UnwrapView<Value, Content: View, Empty: View>: View {
    let value: Value?
    let content: (Value) -> Content
    let empty: (() -> Empty)?
    
    init(
        _ value: Value?,
        @ViewBuilder content: @escaping (Value) -> Content,
        empty: (() -> Empty)? = { EmptyView() }
    ) {
        self.value = value
        self.content = content
        self.empty = empty
    }
    
    var body: some View {
        Group {
            if let value = value {
                content(value)
            } else {
                empty?()
            }
        }
    }
}

//
//  UnwrapView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

struct UnwrapView<Value, Content: View>: View {
    let value: Value?
    let content: (Value) -> Content

    init(_ value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.content = content
    }

    var body: some View {
        Group {
            if let value = value {
                content(value)
            }
        }
    }
}

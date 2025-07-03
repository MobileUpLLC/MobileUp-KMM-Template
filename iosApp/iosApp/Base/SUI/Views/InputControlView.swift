//
//  InputControlView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 14.05.2025.
//

import SwiftUI

struct InputControlView<Label: View>: View {
    typealias InputControl = shared.Kmm_form_validationInputControl
    let item: InputControl
    let placeholder: String
    var label: (() -> Label)?
    
    @StateObject @KotlinStateFlow var text: String
    @FocusState private var isFocused: Bool
    
    init(item: InputControl, placeholder: String = "", label: (() -> Label)? = nil) {
        self.item = item
        self._text = .init(item.value)
        self.placeholder = placeholder
        self.label = label
    }
    
    var body: some View {
        HStack {
            if let label {
                label()
                    .frame(minWidth: 16, idealWidth: 50, maxWidth: 100, alignment: .leading)
                    .lineLimit(1)
            }
            TextField(placeholder, text: $text.wrappedValue)
                .focused($isFocused)
                .onChange(of: text) { newValue in
                    item.onValueChange(value: newValue)
                }
                .onChange(of: isFocused) { newValue in
                    item.onFocusChange(hasFocus: newValue)
                }
        }
    }
}

#Preview {
    InputControlView(item: fakeInputControl()) {
        Text("Label")
    }
}

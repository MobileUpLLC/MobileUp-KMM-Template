//
//  TextFieldContainer.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 21.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

// TODO: https://ascnt.atlassian.net/browse/UPUP-616
/*
enum TextFieldStyle {
    case inline(item: InlineTextFieldItem)
    case multiline(item: MultilineTextFieldItem)
}

struct TextFieldContainer: View {
    @ObservedObject private var text: UnsafeObservableState<NSString>
    @ObservedObject private var error: UnsafeObservableState<StringDesc>
    @ObservedObject private var hasFocus: UnsafeObservableState<KotlinBoolean>
    @ObservedObject private var isEnabled: UnsafeObservableState<KotlinBoolean>
    
    @FocusState private var isFocused: Bool
    
    private let keyboardOptions: Kmm_form_validationKeyboardOptions
    private let inputControl: Kmm_form_validationInputControl
    private let style: TextFieldStyle
    private let onTextChanged: Closure.String
    
    init(inputControl: Kmm_form_validationInputControl, style: TextFieldStyle) {
        self.inputControl = inputControl
        self.style = style
        self.keyboardOptions = inputControl.keyboardOptions
        self.text = UnsafeObservableState(inputControl.text)
        self.error = UnsafeObservableState(inputControl.error)
        self.hasFocus = UnsafeObservableState(inputControl.hasFocus)
        self.isEnabled = UnsafeObservableState(inputControl.enabled)
        self.onTextChanged = { inputControl.onTextChanged(text: $0) }
    }
        
    var body: some View {
        ZStack {
            switch style {
            case .inline(let item):
                InlineTextFieldBodyView(
                    text: text,
                    item: item,
                    isFocused: isFocused,
                    error: error.value,
                    onTextChanged: onTextChanged
                )
            case .multiline(let item):
                MultilineTextFieldBodyView(
                    text: text,
                    item: item,
                    maxLength: inputControl.maxLength,
                    isFocused: isFocused,
                    onTextChanged: onTextChanged
                )
            }
        }
        .disabled((isEnabled.value?.boolValue ?? false) == false)
        .keyboardType(keyboardOptions.keyboardType.toKeyboardType())
        .submitLabel(keyboardOptions.imeAction.toSubmitLabel())
        .textInputAutocapitalization(keyboardOptions.capitalization.toTextInputAutocapitalization())
        .autocorrectionDisabled(keyboardOptions.autoCorrect == false)
        .animation(.easeIn, value: error.value?.localized())
        .animation(.easeIn, value: isFocused)
        .focused($isFocused)
        .onChange(of: isFocused) { newValue in
            inputControl.onFocusChanged(hasFocus: newValue)
        }
        .onChange(of: hasFocus.value?.boolValue == true ) { newValue in
            isFocused = newValue
        }
        .onAppear {
            if #available(iOS 16.0, *) {
                isFocused = hasFocus.value?.boolValue == true
            } else {
                // DispatchQueue For correct work on iOS 15
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = hasFocus.value?.boolValue == true
                }
            }
        }
        .onTapGesture {
            if isFocused == false {
                isFocused = true
            }
        }
    }
}
*/
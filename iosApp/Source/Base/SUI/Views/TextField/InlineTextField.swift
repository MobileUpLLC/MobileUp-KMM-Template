//
//  InlineTextFieldView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 08.06.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI

enum TextFieldInfoItem {
    case text(String)
    case icon(Image, Closure.Void?)
}

struct InlineTextFieldItem {
    let hint: String
    let leftTextFieldInfoItem: TextFieldInfoItem?
    let rightTextFieldInfoItem: TextFieldInfoItem?
    let isShowingErrorMessage: Bool
    let isShowingTopHint: Bool
    let visualTransform: (String) -> String
    let onClearButtonTapped: Closure.Void?
}

struct InlineTextField: View {
    private let inputControl: Kmm_form_validationInputControl
    private let hint: String
    private let leftTextFieldInfoItem: TextFieldInfoItem?
    private let rightTextFieldInfoItem: TextFieldInfoItem?
    private let isShowingErrorMessage: Bool
    private let isShowingTopHint: Bool
    private let visualTransform: (String) -> String
    private let onClearButtonTapped:Closure.Void?
    
    init(
        inputControl: Kmm_form_validationInputControl,
        hint: String,
        leftTextFieldInfoItem: TextFieldInfoItem? = nil,
        rightTextFieldInfoItem: TextFieldInfoItem? = nil,
        isShowingErrorMessage: Bool = true,
        isShowingTopHint: Bool = true,
        visualTransform: @escaping (String) -> String = { return $0 },
        onClearButtonTapped: Closure.Void? = nil
    ) {
        self.inputControl = inputControl
        self.hint = hint
        self.leftTextFieldInfoItem = leftTextFieldInfoItem
        self.rightTextFieldInfoItem = rightTextFieldInfoItem
        self.isShowingErrorMessage = isShowingErrorMessage
        self.isShowingTopHint = isShowingTopHint
        self.visualTransform = visualTransform
        self.onClearButtonTapped = onClearButtonTapped
    }
    
    var body: some View {
        TextFieldContainer(
            inputControl: inputControl,
            style: .inline(
                item: InlineTextFieldItem(
                    hint: hint,
                    leftTextFieldInfoItem: leftTextFieldInfoItem,
                    rightTextFieldInfoItem: rightTextFieldInfoItem,
                    isShowingErrorMessage: isShowingErrorMessage,
                    isShowingTopHint: isShowingTopHint,
                    visualTransform: visualTransform,
                    onClearButtonTapped: onClearButtonTapped
                )
            )
        )
    }
}

struct InlineTextFieldBodyView: View {
    @ObservedObject var text: UnsafeObservableState<NSString>
    
    let item: InlineTextFieldItem
    let isFocused: Bool
    let error: StringDesc?
    let onTextChanged: Closure.String
    
    var body: some View {
        TextFieldView(
            text: Binding(
                get: { item.visualTransform(String(text.value ?? "")) },
                set: { value in
                    onTextChanged(value)
                    text.reemitValue()
                }
            ),
            isFocused: isFocused,
            isShowingErrorMessage: item.isShowingErrorMessage,
            isShowingTopHint: item.isShowingTopHint,
            error: error,
            hint: item.hint,
            leftTextFieldInfoItem: item.leftTextFieldInfoItem,
            rightTextFieldInfoItem: item.rightTextFieldInfoItem,
            onClearButtonTapped: item.onClearButtonTapped
        )
    }
}

private struct TextFieldView: View {
    @Binding var text: String
    
    let isFocused: Bool
    let isShowingErrorMessage: Bool
    let isShowingTopHint: Bool
    let error: StringDesc?
    let hint: String
    let leftTextFieldInfoItem: TextFieldInfoItem?
    let rightTextFieldInfoItem: TextFieldInfoItem?
    let onClearButtonTapped:Closure.Void?
    
    private var shouldHideRulesError: Bool { error == nil }
    private var areValidationRulesPassed: Bool { error == nil }
    private var isAllInfoValid: Bool { areValidationRulesPassed && text.isEmpty == false }
    private var shouldShowHint: Bool { isShowingTopHint && text.isEmpty == false }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(spacing: .zero) {
                    if shouldShowHint {
                        HStack(spacing: .zero) {
                            Text(hint)
                                .foregroundColor(getTopPlaceholderColor())
                                .font(.caption)
                                .padding(.top, .six)
                            
                            Spacer()
                        }
                    }
                    
                    TextFieldBodyView(
                        text: _text,
                        leftTextFieldInfoItem: leftTextFieldInfoItem,
                        rightTextFieldInfoItem: rightTextFieldInfoItem,
                        hint: hint
                    )
                    
                    if shouldShowHint {
                        Spacer()
                    }
                }
                
                if let onClearButtonTapped, text.isEmpty == false {
                    Image("xmark.circle.fill")
                        .foregroundColor(shouldHideRulesError ? .green : .red)
                        .onTapGesture {
                            onClearButtonTapped()
                        }
                        .padding(.leading, .eight)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Color(uiColor: UIColor.lightGray))
            .cornerRadius(16)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(getBorderColor(), lineWidth: getBorderLineWidth())
            }
            
            if isShowingErrorMessage {
                Spacer(minLength: .eight)
                
                if shouldHideRulesError == false && text.isEmpty == false {
                    Text(getErrorMessage())
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(height: isShowingErrorMessage ? 72 : 48)
        .animation(.easeIn, value: shouldHideRulesError)
        .animation(.easeIn, value: shouldShowHint)
        .animation(.easeIn, value: isFocused)
        .animation(.easeIn, value: text.isEmpty)
        .background(.white)
    }
    
    private func getBorderColor() -> Color {
        if shouldHideRulesError == false {
            return .white.opacity(0.02)
        }
        
        if isFocused {
            return .green
        }
        
        return .white.opacity(0.02)
    }
    
    private func getBorderLineWidth() -> CGFloat {
        if shouldHideRulesError == false {
            return .one
        }
        
        if isFocused {
            return .three
        }
        
        return .one
    }
    
    private func getTopPlaceholderColor() -> Color {
        return shouldHideRulesError ? Color(uiColor: UIColor.lightGray) : .red
    }
    
    private func getErrorMessage() -> String {
        if let error {
            return error.localized()
        } else {
            return .empty
        }
    }
}

private struct TextFieldBodyView: View {
    @Binding var text: String
    
    let leftTextFieldInfoItem: TextFieldInfoItem?
    let rightTextFieldInfoItem: TextFieldInfoItem?
    let hint: String
    
    var body: some View {
        HStack(spacing: .four) {
            if let leftTextFieldInfoItem {
                TextFieldItemView(item: leftTextFieldInfoItem)
                    .padding(.trailing, .eight)
            }
            
            TextField(hint, text: $text)
                .font(leftTextFieldInfoItem == nil ? .body : .caption)
                .foregroundColor(.black)
            
            if let rightTextFieldInfoItem {
                TextFieldItemView(item: rightTextFieldInfoItem)
                    .padding(.leading, .eight)
            }
        }
        .tint(Color(uiColor: UIColor.lightGray))
    }
}

private struct TextFieldItemView: View {
    let item: TextFieldInfoItem
    
    var body: some View {
        switch item {
        case .text(let caption):
            Text(caption)
                .font(.body)
                .foregroundColor(Color(uiColor: UIColor.lightGray))
        case let .icon(image, action):
            image
                .onTapGesture {
                    action?()
                }
        }
    }
}

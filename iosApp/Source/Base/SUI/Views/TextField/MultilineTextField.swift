//
//  MultilineInputField.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 06.06.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI

// TODO: https://ascnt.atlassian.net/browse/UPUP-616
/*
struct MultilineTextFieldItem {
    let placeholder: String
    let horizontalPadding: CGFloat
}

struct MultilineTextField: View {
    let inputControl: Kmm_form_validationInputControl
    let placeholder: String
    let horizontalPadding: CGFloat
    
    var body: some View {
        TextFieldContainer(
            inputControl: inputControl,
            style: .multiline(
                item: MultilineTextFieldItem(placeholder: placeholder, horizontalPadding: horizontalPadding)
            )
        )
    }
}

struct MultilineTextFieldBodyView: View {
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
    }
    
    @ObservedObject var text: UnsafeObservableState<NSString>
    
    let item: MultilineTextFieldItem
    let maxLength: Int32
    let isFocused: Bool
    let onTextChanged: Closure.String
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            InnerTextView(
                text: Binding(
                    get: { String(text.value ?? "") },
                    set: { value in
                        onTextChanged(value)
                        text.reemitValue()
                    }
                ),
                placeholder: item.placeholder,
                horizontalPadding: item.horizontalPadding + Constants.horizontalPadding * .two,
                isFocused: isFocused
            )
            .padding(.horizontal, Constants.horizontalPadding)
            
            HStack(spacing: .zero) {
                Spacer(minLength: .zero)
                
                Text(getCountText())
                    .foregroundColor(Color(uiColor: UIColor.lightGray))
                    .font(.caption)
            }
            .padding(.trailing, 12)
        }
        .padding(.bottom, .eight)
        .background(.white)
        .cornerRadius(16)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(getBorderColor(), lineWidth: getBorderlineWidth())
        }
    }
    
    private func getCountText() -> String {
        return (text.value?.description.count ?? .zero).description
    }
    
    private func getBorderColor() -> Color {
        return isFocused
            ? .green
            : .white.opacity(0.02)
    }
    
    private func getBorderlineWidth() -> CGFloat {
        return isFocused ? .three : .one
    }
}

private struct InnerTextView: View {
    @Binding var text: String
    
    let placeholder: String
    let horizontalPadding: CGFloat
    let isFocused: Bool
    
    var body: some View {
        InputTextRepresentableView(
            value: $text,
            horizontalPadding: horizontalPadding
        )
        .padding(.top, 20)
        .placeholder(
            alignment: .topLeading,
            placeholder: placeholder,
            topPadding: getPlaceholderPadding(),
            font: getPlaceholderFont()
        )
    }
    
    private func getPlaceholderPadding() -> CGFloat {
        return text.isEmpty ? 20 : .six
    }
    
    private func getPlaceholderFont() -> Font {
        return text.isEmpty ? .body : .caption
    }
}

private extension View {
    func placeholder(
        alignment: Alignment = .leading,
        placeholder: String,
        topPadding: CGFloat,
        font: Font
    ) -> some View {
        ZStack(alignment: alignment) {
            Text(placeholder)
                .foregroundColor(Color(uiColor: .lightGray))
                .font(font)
                .disabled(true)
                .padding(.top, topPadding)
                .animation(.easeIn(duration: 0.1), value: topPadding)
            
            self
        }
    }
}

private struct InputTextRepresentableView: UIViewRepresentable {
    @Binding private var value: String
    
    private let isScrollEnabled: Bool
    private let horizontalPadding: CGFloat
    
    init(value: Binding<String>, horizontalPadding: CGFloat, isScrollEnabled: Bool = false) {
        self._value = value
        self.horizontalPadding = horizontalPadding
        self.isScrollEnabled = isScrollEnabled
    }
    
    static func dismantleUIView(_ uiView: InputTextView, coordinator: ()) {
        uiView.delegate = nil
    }
    
    func makeUIView(context: Context) -> InputTextView {
        let view = InputTextView(frame: .zero, textContainer: nil, onValueDidChange: { _value.wrappedValue = $0 })
        view.text = value
        view.isScrollEnabled = isScrollEnabled
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - horizontalPadding).isActive = true
        
        return view
    }
    
    func updateUIView(_ uiView: InputTextView, context: Context) {}
}

private class InputTextView: UITextView, UITextViewDelegate {
    private var onValueDidChange: Closure.String
    
    init(frame: CGRect, textContainer: NSTextContainer?, onValueDidChange: @escaping Closure.String) {
        self.onValueDidChange = onValueDidChange
        
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        assertionFailure(DeveloperService.Messages.initHasNotBeenImplemented)
        
        return nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        onValueDidChange(text)
    }
    
    private func setup() {
        delegate = self
        textColor = .black
        tintColor = .lightGray
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        backgroundColor = .clear
        textContainerInset = .zero
        textContainer.lineFragmentPadding = .zero
        isScrollEnabled = false
    }
}
*/
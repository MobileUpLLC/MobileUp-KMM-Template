//
//  ToastGlobalValueModifier.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

struct ToastGlobalValueModifier: ViewModifier {
    @Binding var message: Message?
    let duration: TimeInterval = 3.0
    let onAction: Closure.Void?
    
    @EnvironmentObject private var toastRouter: ToastRouter
    @State private var toastItem: ToastItem?
    @State private var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: message) { newValue in
                if let newValue {
                    toastItem = .info(
                        title: newValue.actionTitle?.localized(),
                        text: newValue.text.localized(),
                        image: nil,
                        onAction: onAction
                    )
                    isPresented = true
                } else  {
                    isPresented = false
                    toastItem = nil
                }
            }
            .onChange(of: isPresented) { newIsPresented in
                if newIsPresented {
                    DispatchQueue.main.async {
                        self.isPresented = false
                    }
                    toastRouter.showToast(item: toastItem, duration: duration)
                }
            }
    }
}

extension View {
    func toast(message: Binding<Message?>, onAction: Closure.Void? = nil) -> some View {
        self.modifier(ToastGlobalValueModifier(message: message, onAction: onAction))
    }
}

//
//  ToastGlobalValueModifier.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

struct ToastGlobalValueModifier: ViewModifier {
    @Binding var message: Message?
    let duration: TimeInterval?
    let onAction: Closure.Void?
    
    @EnvironmentObject private var toastRouter: ToastRouter
    @State private var toastItem: ToastItem?
    @State private var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: message) { newValue in
                if let newValue {
                    toastItem = .init(message: newValue)
                    isPresented = true
                } else {
                    isPresented = false
                    toastItem = nil
                }
            }
            .onChange(of: isPresented) { newIsPresented in
                if newIsPresented {
                    toastRouter.showToast(item: toastItem, duration: duration)
                } else {
                    toastRouter.dismissToast()
                }
            }
    }
}

extension View {
    func toast(message: Binding<Message?>, duration: TimeInterval?, onAction: Closure.Void? = nil) -> some View {
        self.modifier(ToastGlobalValueModifier(message: message, duration: duration, onAction: onAction))
    }
}

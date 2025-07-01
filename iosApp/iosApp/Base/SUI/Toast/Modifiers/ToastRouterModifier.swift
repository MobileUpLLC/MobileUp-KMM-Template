//
//  ToastRouterModifier.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

struct ToastRouterModifier<ToastContent: View>: ViewModifier {
    let toastContent: (ToastItem) -> ToastContent
    @EnvironmentObject private var toastRouter: ToastRouter
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if toastRouter.isShowing, let item = toastRouter.item {
                    toastContent(item)
                        .padding(.bottom, 20)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                }
            }
            .animation(.easeInOut, value: toastRouter.isShowing)
    }
}

extension View {
    func addToastGlobal<ToastContent: View>(content: @escaping (ToastItem) -> ToastContent) -> some View {
        self.modifier(ToastRouterModifier(toastContent: content))
    }
}

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
        ZStack(alignment: .bottom) {
            content
            if toastRouter.isShowing, let item = toastRouter.item {
                toastContent(item)
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: toastRouter.isShowing)
    }
}

extension View {
    func addToastGlobal<ToastContent: View>(content: @escaping (ToastItem) -> ToastContent) -> some View {
        self.modifier(ToastRouterModifier(toastContent: content))
    }
}

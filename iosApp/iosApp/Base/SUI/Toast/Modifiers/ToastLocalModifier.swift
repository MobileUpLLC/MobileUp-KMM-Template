//
//  ToastLocalModifier.swift
//  Barcelona
//
//  Created by Denis Dmitriev on 10.03.2025.
//

import SwiftUI

struct ToastLocalModifier<ToastContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    
    let item: ToastItem?
    let toastContent: (ToastItem) -> ToastContent
    let toastRouter: ToastRouter = .init()
    let duration: TimeInterval = 3.0
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if toastRouter.isShowing, let item = toastRouter.item {
                toastContent(item)
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: toastRouter.isShowing)
        .onChange(of: isPresented) { newIsPresented in
            if newIsPresented {
                DispatchQueue.main.async {
                    self.isPresented = false
                }
                toastRouter.showToast(item: item, duration: duration)
            }
        }
    }
}

extension View {
    func toastLocal<ToastContent: View>(isPresented: Binding<Bool>, item: ToastItem?, content: @escaping (ToastItem) -> ToastContent) -> some View {
        self.modifier(ToastLocalModifier(isPresented: isPresented, item: item, toastContent: content))
    }
}

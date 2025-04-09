//
//  ToastGlobalModifier.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

struct ToastGlobalModifier: ViewModifier {
    @Binding var isPresented: Bool
    let item: ToastItem?
    let duration: TimeInterval = 3.0
    
    @EnvironmentObject private var toastRouter: ToastRouter
    
    func body(content: Content) -> some View {
        content
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
    func toast(isPresented: Binding<Bool>, item: ToastItem?) -> some View {
        self.modifier(ToastGlobalModifier(isPresented: isPresented, item: item))
    }
}

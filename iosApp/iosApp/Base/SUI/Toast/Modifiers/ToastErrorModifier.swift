//
//  ToastErrorModifier.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

struct ToastErrorModifier<Failure>: ViewModifier where Failure: LocalizedError {
    @Binding var isPresented: Bool
    let error: Failure?
    let duration: TimeInterval = 3.0
    
    @EnvironmentObject private var toastRouter: ToastRouter
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { newIsPresented in
                if newIsPresented, let error {
                    DispatchQueue.main.async {
                        self.isPresented = false
                    }
                    toastRouter.showToast(item: .info(title: "Error", text: error.localizedDescription, image: nil, onAction: nil), duration: duration)
                }
            }
    }
}

extension View {
    func toast<Failure>(
        isPresented: Binding<Bool>,
        error: Failure?
    ) -> some View where Failure: LocalizedError {
        self.modifier(ToastErrorModifier(isPresented: isPresented, error: error))
    }
}

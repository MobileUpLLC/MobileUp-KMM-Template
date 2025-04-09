//
//  ToastView.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

struct ToastView: View {
    @EnvironmentObject var toastRouter: ToastRouter
    
    let item: ToastItem
    
    var body: some View {
        Group {
            HStack {
                switch item {
                case let .info(title, text, image, onAction):
                    Text(text)
                        .foregroundColor(.white)
                    if let title {
                        Spacer(minLength: 16)
                        
                        Button(title) {
                            onAction?()
                        }
                        .foregroundColor(.green)
                        .font(.body.bold())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            switch item {
            case .info:
                Color.black.opacity(0.75)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.bottom, 60)
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    ToastView(item: .info(title: "Finish!", text: "Info text", onAction: nil))
        .environmentObject(ToastRouter())
}

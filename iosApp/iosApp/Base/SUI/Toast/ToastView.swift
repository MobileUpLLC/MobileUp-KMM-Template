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
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.text)
                        .font(.caption)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let actionTitle = item.actionTitle {
                    Button(actionTitle) {
                        item.onAction?()
                    }
                    .foregroundColor(.green)
                    .font(.body.bold())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background { Color(.gray) }
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 60)
    }
}

#Preview {
    VStack {
        ToastView(item: .init(
            text: "Some text",
            onAction: nil
        ))
        ToastView(item: .init(
            text: "Some text",
            onAction: nil
        ))
        ToastView(item: .init(
            text: "Some text",
            onAction: nil
        ))
    }
    .environmentObject(ToastRouter())
}

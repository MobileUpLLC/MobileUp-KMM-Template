//
//  RadioItemView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 25.04.2025.
//

import SwiftUI

struct RadioItemView: View {
    let label: String
    let description: String?
    @Binding var isSelected: Bool
    let routeAction: (() -> Void)?
    
    init(
        label: String,
        description: String? = nil,
        isSelected: Binding<Bool>,
        routeAction: (() -> Void)? = nil
    ) {
        self.label = label
        self.description = description
        self._isSelected = isSelected
        self.routeAction = routeAction
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                isSelected.toggle()
            } label: {
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: 14, height: 14)
                    .overlay {
                        let size: CGFloat = isSelected ? 10 : 0
                        Circle()
                            .fill()
                            .frame(width: size, height: size)
                            .transition(.scale)
                    }
            }
            .animation(.easeInOut, value: isSelected)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                if let description {
                    Text(description)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let routeAction {
                Button {
                    routeAction()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal)
            }
        }
        .background(.white.opacity(0.0001))
        .onTapGesture {
            isSelected.toggle()
        }
        .animation(.easeInOut, value: isSelected)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isSelected = false
        
        var body: some View {
            VStack {
                RadioItemView(
                    label: "Label",
                    description: "Description",
                    isSelected: $isSelected,
                    routeAction: {}
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

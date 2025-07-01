//
//  SearchFieldGesture.swift
//  iosApp
//
//  Created by Denis Dmitriev on 23.06.2025.
//

import SwiftUI

extension View {
    func searchFieldGesture(text: Binding<String>, isActive: Binding<Bool>, scrollOffset: Binding<CGPoint>) -> some View {
        modifier(SearchFieldGesture(text: text, isActive: isActive, scrollOffset: scrollOffset))
    }
}

struct SearchFieldGesture: ViewModifier {
    @Binding var text: String
    @Binding var isActive: Bool
    @Binding var scrollOffset: CGPoint
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        // Активируем поиск, если тянем вниз и список вверху
                        if scrollOffset.y < 0 && value.translation.height > 10 {
                            withAnimation {
                                isActive = true
                            }
                        } else if scrollOffset.y >= 0 && text.isEmpty && value.translation.height < -10 {
                            withAnimation {
                                isActive = false
                            }
                        }
                    }
            )
    }
}

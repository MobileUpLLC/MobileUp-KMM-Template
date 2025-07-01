//
//  BottomSheet.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

extension View {
    func bottomSheet<PopupContent: View>(
        isPresented: Binding<Bool>,
        dragToDismiss: Bool = true,
        closeOnTapOutside: Bool = true,
        useKeyboardSafeArea: Bool = true,
        cornerRadius: CGFloat = .zero,
        onDismiss: Closure.Void? = nil,
        @ViewBuilder view: @escaping () -> PopupContent
    ) -> some View {
        self.popup(
            isPresented: isPresented,
            view: view,
            customize: {
                $0
                    .type(.floater(verticalPadding: .zero, useSafeAreaInset: false))
                    .position(.bottom)
                    .animation(.easeIn(duration: 0.2))
                    .closeOnTap(false)
                    .closeOnTapOutside(closeOnTapOutside)
                    .dragToDismiss(dragToDismiss)
                    .displayMode(.sheet)
                    .backgroundColor(.black.opacity(0.6))
                    .useKeyboardSafeArea(useKeyboardSafeArea)
                    .dismissCallback { onDismiss?() }
                    .useCornerRadius(cornerRadius)
            }
        )
    }
}

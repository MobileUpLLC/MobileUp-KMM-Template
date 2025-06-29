//
//  BottomSheetChild.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

extension View {
    func bottomSheet<PopupContent: View, T: AnyObject, M: AnyObject>(
        childSlot: ChildSlot<AnyObject, T>,
        dialogControl: DialogControl<M, T>,
        dragToDismiss: Bool = true,
        closeOnTapOutside: Bool = true,
        useKeyboardSafeArea: Bool = true,
        onDismiss: Closure.Void? = nil,
        @ViewBuilder view: @escaping () -> PopupContent
    ) -> some View {
        modifier(
            BottomSheetChild(
                childSlot: childSlot,
                dialogControl: dialogControl,
                dragToDismiss: dragToDismiss,
                closeOnTapOutside: closeOnTapOutside,
                useKeyboardSafeArea: useKeyboardSafeArea,
                onDismiss: onDismiss,
                view: view
            )
        )
    }
}

struct BottomSheetChild<PopupContent: View, T: AnyObject, M: AnyObject>: ViewModifier {
    let childSlot: ChildSlot<AnyObject, T>
    let dialogControl: DialogControl<M, T>
    let dragToDismiss: Bool
    let closeOnTapOutside: Bool
    let useKeyboardSafeArea: Bool
    let onDismiss: Closure.Void?
    let view: () -> PopupContent
    
    @State private var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .bottomSheet(
                isPresented: $isPresented,
                dragToDismiss: dragToDismiss,
                closeOnTapOutside: closeOnTapOutside,
                useKeyboardSafeArea: useKeyboardSafeArea,
                onDismiss: onDismiss,
                view: view
            )
            .onChange(of: isPresented) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dialogControl.dismiss()
                    }
                }
            }
            .onChange(of: childSlot.child) { newValue in
                if newValue != nil {
                    isPresented = true
                } else {
                    isPresented = false
                }
            }
    }
}

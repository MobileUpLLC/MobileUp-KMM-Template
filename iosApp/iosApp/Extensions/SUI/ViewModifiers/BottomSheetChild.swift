//
//  BottomSheetChild.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

extension View {
    func bottomSheet<PopupContent: View, T: AnyObject>(
        childSlot: ChildSlot<AnyObject, T>,
        dialogControl: DialogControl<AnyObject, T>,
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
                topTrailingView: { _ in EmptyView() },
                view: view
            )
        )
    }
    
    func bottomSheetComponent<PopupContent: View, TopTrailingView: View, T: AnyObject>(
        childSlot: ChildSlot<AnyObject, T>,
        dialogControl: DialogControl<AnyObject, T>,
        dragToDismiss: Bool = true,
        closeOnTapOutside: Bool = true,
        useKeyboardSafeArea: Bool = true,
        onDismiss: Closure.Void? = nil,
        @ViewBuilder topTrailingView: @escaping (Binding<Bool>) -> TopTrailingView = { _ in EmptyView() },
        @ViewBuilder view: @escaping (T) -> PopupContent
    ) -> some View {
        modifier(
            BottomSheetChild(
                childSlot: childSlot,
                dialogControl: dialogControl,
                dragToDismiss: dragToDismiss,
                closeOnTapOutside: closeOnTapOutside,
                useKeyboardSafeArea: useKeyboardSafeArea,
                onDismiss: onDismiss,
                topTrailingView: topTrailingView,
                view: {
                    ChildSlotView(control: dialogControl) { component in
                        view(component)
                    }
                }
            )
        )
    }
}

struct BottomSheetChild<PopupContent: View, TopTrailingView: View, T: AnyObject>: ViewModifier {
    let childSlot: ChildSlot<AnyObject, T>
    let dialogControl: DialogControl<AnyObject, T>
    let dragToDismiss: Bool
    let closeOnTapOutside: Bool
    let useKeyboardSafeArea: Bool
    let onDismiss: Closure.Void?
    let topTrailingView: (Binding<Bool>) -> TopTrailingView
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
                view: {
                    view()
                        .roundedCorner(10, corners: [.topLeft, .topRight])
                        .overlay(alignment: .top) {
                            Capsule()
                                .fill(Color.accentColor.opacity(0.5))
                                .frame(width: 36, height: 5)
                                .padding(.top, 6)
                        }
                        .environment(\.dismissDialogAction, {
                            Task { @MainActor in
                                isPresented = false
                            }
                        })
                        .overlay(alignment: .topTrailing) {
                            topTrailingView($isPresented)
                        }
                }
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

private struct DismissActionKey: EnvironmentKey {
    static let defaultValue: @Sendable () -> Void = {}
}

extension EnvironmentValues {
    @MainActor
    var dismissDialogAction: @Sendable () -> Void {
        get { self[DismissActionKey.self] }
        set { self[DismissActionKey.self] = newValue }
    }
}

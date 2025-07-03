//
//  AlertChild.swift
//  iosApp
//
//  Created by Denis Dmitriev on 09.04.2025.
//

import SwiftUI

extension View {
    func alertChild<S: StringProtocol, A: View, M: View, Z: AnyObject>(
        _ title: S,
        childSlot: ChildSlot<AnyObject, Z>,
        @ViewBuilder actions: @escaping () -> A,
        @ViewBuilder message: @escaping () -> M
    ) -> some View {
        self.modifier(
            AlertChild(
                title: title,
                childSlot: childSlot,
                actions: actions,
                message: message
            )
        )
    }
    
    func alertComponent<A: View, M: View, Z: AnyObject>(
        childSlot: ChildSlot<AnyObject, Z>,
        @ViewBuilder actions: @escaping (StandardDialogData) -> A,
        @ViewBuilder message: @escaping (StandardDialogData) -> M
    ) -> some View {
        self.modifier(
            AlertComponent(
                childSlot: childSlot,
                actions: actions,
                message: message
            )
        )
    }
}

struct AlertChild<S: StringProtocol, A: View, M: View, Z: AnyObject>: ViewModifier {
    let title: S
    let childSlot: ChildSlot<AnyObject, Z>
    @ViewBuilder let actions: () -> A
    @ViewBuilder let message: () -> M
    
    @State private var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: childSlot.child) { newValue in
                if newValue != nil {
                    isPresented = true
                } else {
                    isPresented = false
                }
            }
            .alert(
                title,
                isPresented: $isPresented,
                actions: actions,
                message: message
            )
    }
}

struct AlertComponent<A: View, M: View, Dialog: AnyObject>: ViewModifier {
    let childSlot: ChildSlot<AnyObject, Dialog>
    @ViewBuilder let actions: (StandardDialogData) -> A
    @ViewBuilder let message: (StandardDialogData) -> M
    
    @State private var isPresented: Bool = false
    
    private var dialogData: StandardDialogData {
        childSlot.child?.instance as? StandardDialogData ?? .empty
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: childSlot.child) { newValue in
                if newValue != nil {
                    isPresented = true
                } else {
                    isPresented = false
                }
            }
            .alert(
                dialogData.title.localized(),
                isPresented: $isPresented,
                actions: { actions(dialogData) },
                message: { message(dialogData) }
            )
    }
}

extension StandardDialogData {
    static var empty: Self {
        .init(
            title: "".desc(),
            confirmButton: DialogButton(text: "".desc(), action: {})
        )
    }
}

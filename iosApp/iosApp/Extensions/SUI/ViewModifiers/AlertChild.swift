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

//
//  ChildSlotView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 20.05.2025.
//

import SwiftUI

struct ChildSlotView<T : AnyObject, Content: View>: View {
    private let content: (T) -> Content
    
    @StateObject @KotlinStateFlow private var childSlot: ChildSlot<AnyObject, T>
    
    init(control: DialogControl<AnyObject, T>, content: @escaping (T) -> Content) {
        self._childSlot = .init(control.dialogSlot)
        self.content = content
    }
    
    var body: some View {
        UnwrapView(childSlot.child?.instance) { component in
            content(component)
        }
    }
}

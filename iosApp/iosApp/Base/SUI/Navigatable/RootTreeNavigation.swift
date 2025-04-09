//
//  RootTreeNavigation.swift
//  iosApp
//
//  Created by Denis Dmitriev on 09.04.2025.
//

import SwiftUI

struct RootTreeNavigation<C: AnyObject, Destination: Hashable & AnyObject>: ViewModifier {
    @ObservedObject var childStack: ObservableState<ChildStack<C, Destination>>
    let navigationModel: any ObservableNavigation
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if
                    navigationModel.flatPath.isEmpty,
                    let root = childStack.value.items.compactMap({ $0.instance }).first
                {
                    navigationModel.syncPath(state: .root(root), type: type(of: root))
                }
            }
    }
}

extension View {
    func setRootTreeNavigation<C: AnyObject, Destination: Hashable & AnyObject>(
        childStack: ObservableState<ChildStack<C, Destination>>,
        navigationModel: any ObservableNavigation
    ) -> some View {
        self.modifier(
            RootTreeNavigation(
                childStack: childStack,
                navigationModel: navigationModel
            )
        )
    }
}

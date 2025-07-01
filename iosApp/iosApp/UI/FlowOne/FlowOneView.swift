//
//  LibraryView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

struct FlowOneView: View {
    let component: Flow1Component
    
    @StateObject @KotlinStateFlow private var childStack: ChildStack<AnyObject, Flow1ComponentChild>
    
    private var rootItem: Router.Flow1Component {
        childStack.items
            .compactMap({ $0.instance })
            .map({ onEnum(of: $0) })
            .first ?? .screen1A(.init(component: FakeScreen1AComponent()))
    }
    
    init(component: Flow1Component) {
        self.component = component
        self._childStack = .init(component.childStack)
    }
    
    var body: some View {
        Router.destination(for: .flow1(rootItem))
            .navigationBranch(
                childStack: _childStack.wrappedValue
            ) { destination in
                Router.flow1(onEnum(of: destination))
            }
    }
}

#Preview {
    FlowOneView(component: FakeFlow1Component())
}

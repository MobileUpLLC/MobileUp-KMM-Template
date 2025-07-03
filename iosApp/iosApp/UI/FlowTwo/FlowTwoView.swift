//
//  LibraryView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

struct FlowTwoView: View {
    let component: Flow2Component
    
    @StateObject @KotlinStateFlow private var childStack: ChildStack<AnyObject, Flow2ComponentChild>
    
    private var rootItem: Router.Flow2Component {
        childStack.items
            .compactMap({ $0.instance })
            .map({ onEnum(of: $0) })
            .first ?? .screen2A(.init(component: FakeScreen2AComponent()))
    }
    
    init(component: Flow2Component) {
        self.component = component
        self._childStack = .init(component.childStack)
    }
    
    var body: some View {
        Router.destination(for: .flow2(rootItem))
            .navigationBranch(
                childStack: _childStack.wrappedValue
            ) { destination in
                Router.flow2(onEnum(of: destination))
            }
    }
}

#Preview {
    FlowOneView(component: FakeFlow1Component())
}

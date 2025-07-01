//
//  RootView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 12.05.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @StateObject @KotlinOptionalStateFlow private var message: Message?
    @StateObject @KotlinStateFlow var childStack: ChildStack<AnyObject, RootComponentChild>
    @State private var isTabPresent: Bool = false
    
    private let component: RootComponent
    
    private var rootItem: Router.RootComponent {
        childStack.items.compactMap({ $0.instance }).map({ onEnum(of: $0) }).first
        ?? .flow1(.init(component: FakeFlow1Component()))
    }
    
    private var rootItemIsTab: Bool {
        return childStack.items.compactMap({ $0.instance }).first?.getTabComponent() != nil
    }
    
    init(component: RootComponent) {
        self.component = component
        self._message = .init(component.messageComponent.visibleMessage)
        self._childStack = .init(component.childStack)
    }
    
    var body: some View {
        TabOrNavigationView(
            childStack: _childStack.wrappedValue,
            getTabComponentAction: { $0.getTabComponent() },
            tab: { component in
                HomeView(component: component)
            },
            navigation: {
                NavigationStack(path: $navigationModel.path) {
                    Router.destination(for: rootItemIsTab ? .empty : .root(rootItem))
                        .navigationDestination(for: Router.self, destination: Router.destination(for:))
                        .navigationBranch(
                            childStack: _childStack.wrappedValue
                        ) { destination in
                            Router.root(onEnum(of: destination))
                        }
                        .backNavigationHandler()
                }
            }
        )
        .toast(message: $message.wrappedValue, duration: nil, onAction: component.messageComponent.onActionClick)
    }
}

#Preview {
    RootView(component: FakeRootComponent())
        .environmentObject(ToastRouter())
        .environmentObject(NavigationModel())
}

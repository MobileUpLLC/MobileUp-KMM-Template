//
//  FlowOneView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FlowOneView: View, TreeNavigation {
    @EnvironmentObject private var navigationModel: TreeNavigationModel
    @StateObject @KotlinStateFlow var childStack: ChildStack<AnyObject, Flow1ComponentChild>
    
    private let component: Flow1Component
    
    init(component: Flow1Component) {
        self.component = component
        self._childStack = .init(component.childStack)
    }
    
    var body: some View {
        rootView
            .treeNavigation(childStack: _childStack.wrappedValue, navigationModel: navigationModel, destination: destination(for:))
    }
    
    @ViewBuilder
    func destination(for item: Flow1ComponentChild) -> some View {
        switch onEnum(of: item) {
        case .screen1A(let child):
            ScreenOneAView(component: child.component)
        case .screen1B(let child):
            ScreenOneBView(component: child.component)
        case .screen1C(let child):
            ScreenOneCView(component: child.component)
        }
    }
}

#Preview {
    FlowOneView(component: FakeFlow1Component())
        .environmentObject(TreeNavigationModel())
}

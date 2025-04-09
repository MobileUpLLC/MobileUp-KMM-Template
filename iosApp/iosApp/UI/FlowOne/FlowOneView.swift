//
//  FlowOneView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FlowOneView: View, TreeNavigation {
    @EnvironmentObject private var navigationModel: RootNavigationModel
    @ObservedObject var childStack: ObservableState<ChildStack<AnyObject, Flow1ComponentChild>>
    
    private let component: Flow1Component
    
    private let onBack: Closure.Void = { BackDispatcherService.shared.backDispatcher.back() }
    
    init(component: Flow1Component) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        rootView
            .treeNavigation(childStack: childStack, navigationModel: navigationModel, destination: destination(for:))
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
        .environmentObject(RootNavigationModel())
}

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
        switch item {
        case let screen1A as Flow1ComponentChild.Screen1A:
            ScreenOneAView(component: screen1A.component)
        case let screen1B as Flow1ComponentChild.Screen1B:
            ScreenOneBView(component: screen1B.component)
        case let screen1C as Flow1ComponentChild.Screen1C:
            ScreenOneCView(component: screen1C.component)
        default:
            EmptyView()
        }
    }
}

#Preview {
    FlowOneView(component: FakeFlow1Component())
        .environmentObject(RootNavigationModel())
}

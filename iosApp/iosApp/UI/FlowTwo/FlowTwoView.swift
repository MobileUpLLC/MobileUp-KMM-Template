//
//  FlowTwoView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FlowTwoView: View, TreeNavigation {
    @EnvironmentObject var navigationModel: RootNavigationModel
    @ObservedObject var childStack: ObservableState<ChildStack<AnyObject, Flow2ComponentChild>>
    
    private let component: Flow2Component
    
    init(component: Flow2Component) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        rootView
            .treeNavigation(childStack: childStack, navigationModel: navigationModel, destination: destination(for:))
    }
    
    @ViewBuilder
    func destination(for item: Flow2ComponentChild) -> some View {
        switch item {
        case let screen1A as Flow2ComponentChild.Screen2A:
            ScreenTwoAView(component: screen1A.component)
        case let screen1B as Flow2ComponentChild.Screen2B:
            ScreenTwoBView(component: screen1B.component)
        case let screen1C as Flow2ComponentChild.Screen2C:
            ScreenTwoCView(component: screen1C.component)
        default:
            EmptyView()
        }
    }
}

#Preview {
    FlowTwoView(component: FakeFlow2Component())
        .environmentObject(RootNavigationModel())
}

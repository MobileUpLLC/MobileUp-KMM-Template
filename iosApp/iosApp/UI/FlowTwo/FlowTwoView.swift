//
//  FlowTwoView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FlowTwoView: View, TreeNavigation {
    @EnvironmentObject var navigationModel: TreeNavigationModel
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
        switch onEnum(of: item) {
        case .screen2A(let child):
            ScreenTwoAView(component: child.component)
        case .screen2B(let child):
            ScreenTwoBView(component: child.component)
        case .screen2C(let child):
            ScreenTwoCView(component: child.component)
        }
    }
}

#Preview {
    FlowTwoView(component: FakeFlow2Component())
        .environmentObject(TreeNavigationModel())
}

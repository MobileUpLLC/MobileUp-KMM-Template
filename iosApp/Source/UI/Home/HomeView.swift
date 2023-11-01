//
//  HomeView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var childStack: ObservableStateFlow<ChildStack<AnyObject, HomeComponentChild>>
    
    private let component: HomeComponent
    
    init(component: HomeComponent) {
        self.component = component
        self.childStack = ObservableStateFlow(flow: component.childStack)
        Task.init { [self] in
            await self.childStack.activate()
        }
    }
    
    var body: some View {
        HomeTabBarView(
            tabsStack: childStack,
            tabScreen: { child in
                switch onEnum(of: child) {
                case .tab1(let child):
                    return TabOneController(component: child.component)
                case .tab2(let child):
                    return TabTwoController(component: child.component)
                case .tab3(let child):
                    return PokemonController(component: child.component)
                }
            },
            onTabSelected: { homeTab in
                component.onTabSelected(tab: homeTab)
            }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(component: FakeHomeComponent())
    }
}

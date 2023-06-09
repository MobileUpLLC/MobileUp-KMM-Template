//
//  HomeView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    private let component: HomeComponent
    
    init(component: HomeComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        HomeTabBarView(
            tabsStack: childStack,
            tabScreen: { child in
                switch child {
                case let tabOne as HomeComponentChild.Tab1:
                    return TabOneController(component: tabOne.component)
                case let tabTwo as HomeComponentChild.Tab2:
                    return TabTwoController(component: tabTwo.component)
                case let pokemons as HomeComponentChild.Tab3:
                    return PokemonController(component: pokemons.component)
                default:
                    return nil
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

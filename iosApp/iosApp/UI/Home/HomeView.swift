//
//  HomeView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    @State private var selection: HomeTab = .tab1
    
    private let component: HomeComponent
    
    init(component: HomeComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(HomeTab.entries, id: \.self) { tab in
                Group {
                    if let childTab = getChildComponent(for: tab) {
                        switch childTab {
                        case let tabOne as HomeComponentChild.Tab1:
                            TabOneView(component: tabOne.component)
                        case let tabTwo as HomeComponentChild.Tab2:
                            TabTwoView(component: tabTwo.component)
                        case let pokemons as HomeComponentChild.Tab3:
                            PokemonView(component: pokemons.component)
                        default:
                            Color.clear
                        }
                    } else {
                        Color.clear
                    }
                }
                .tabItem { tab.label }
                .tag(tab)
            }
        }
        .onChange(of: selection) { newSelection in
            component.onTabSelected(tab: newSelection)
        }
    }
    
    private func getChildComponent(for tab: HomeTab) -> HomeComponentChild? {
        switch tab {
        case .tab1:
            return childStack.value.items.first(where: { $0.instance is HomeComponentChild.Tab1 })?.instance
        case .tab2:
            return childStack.value.items.first(where: { $0.instance is HomeComponentChild.Tab2 })?.instance
        case .tab3:
            return childStack.value.items.first(where: { $0.instance is HomeComponentChild.Tab3 })?.instance
        default:
            return nil
        }
    }
}

extension HomeTab {
    var title: String {
        switch self {
        case .tab1:
            return MR.strings().home_tab1_label.desc().localized()
        case .tab2:
            return MR.strings().home_tab2_label.desc().localized()
        case .tab3:
            return MR.strings().home_tab3_label.desc().localized()
        default:
            return .empty
        }
    }
    
    var image: String {
        switch self {
        case .tab1:
            return "1.square"
        case .tab2:
            return "2.square"
        case .tab3:
            return "3.square"
        default:
            return ""
        }
    }
    
    var label: some View {
        Label(title, systemImage: image)
    }
}

#Preview {
    HomeView(component: FakeHomeComponent())
}


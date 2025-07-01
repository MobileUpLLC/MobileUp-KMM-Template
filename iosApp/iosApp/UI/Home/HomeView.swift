//
//  MainView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

extension HomeComponentChild: @retroactive Identifiable {
    public var id: String {
        self.description
    }
}

struct HomeView: View {
    let component: HomeComponent
    
    // FIXME: раньше тут был @StateObject, стоит перепроверить, норм ли использовать @ObservedObject, тк писал Android-разработчик
    @ObservedObject @KotlinStateFlow private var childStack: ChildStack<AnyObject, HomeComponentChild>
    @StateObject @KotlinStateFlow private var selectedTab: HomeTab
    
    init(component: HomeComponent) {
        self.component = component
        self._childStack = .init(component.childStack)
        self._selectedTab = .init(component.selectedTab)
    }
    
    var body: some View {
        TabView(selection: $selectedTab.wrappedValue) {
            let tabs = HomeTab.allCases
            ForEach(tabs) { tab in
                let componentChildSealed = tab.componentChild(for: childStack)?.sealed
                UnwrapView(componentChildSealed) { componentChildSealed in
                    Router.destination(for: .home(componentChildSealed))
                } empty: {
                    // Пока мы не сделаем переход, не будет создано компонента
                    // Поэтому мы создаем пустой экран (плейсхолдер) таба
                    // Как только переход будет, создастся компонент и экран
                    Color.clear
                }
                .tabItem {
                    tab.label
                }
                .tag(tab)
            }
        }
        .onChange(of: selectedTab) { newSelectionTab in
            component.onTabSelected(tab: newSelectionTab)
        }
    }
}

#Preview {
    HomeView(component: FakeHomeComponent())
        .environmentObject(ToastRouter())
        .environmentObject(NavigationModel())
}

//
//  TabOrNavigationView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 04.06.2025.
//

import SwiftUI

/// Компонент для управления переключением между TabView и NavigationStack в приложении iOS, использующем Kotlin Multiplatform (KMP).
///
/// Решает проблему совместимости древовидной навигации KMP с ограничениями SwiftUI, где TabView не может находиться внутри NavigationStack.
/// Динамически отображает либо TabView, либо NavigationStack на основе текущего состояния стека навигации.
final class TabComponentWrapper<Component: AnyObject>: ObservableObject {
    @Published var component: Component?
    
    init(component: Component? = nil) {
        self.component = component
    }
}

/// Представление, которое адаптирует древовидную навигацию KMP для SwiftUI, переключая между TabView и NavigationStack.
///
/// Использует ZStack для наложения контента табов поверх навигации с анимацией переключения.
struct TabOrNavigationView<Destination: AnyObject, TabComponent: AnyObject, TabContent: View, NavigationContent: View>: View {
    @ObservedObject private var childStack: KotlinStateFlow<ChildStack<AnyObject, Destination>>
    @StateObject private var tabComponent: TabComponentWrapper<TabComponent>
    @State private var showTabItem: Bool = false
    private let getTabComponentAction: (Destination) -> TabComponent?
    private let tabContent: (TabComponent) -> TabContent
    private let navigationContent: () -> NavigationContent
    
    /// Инициализатор компонента.
    /// - Parameters:
    ///   - childStack: Поток состояния стека навигации из KMP.
    ///   - getTabComponentAction: Функция для получения компонента табов из текущего destination.
    ///   - tab: Замыкание, возвращающее содержимое TabView для переданного компонента.
    ///   - navigation: Замыкание, возвращающее содержимое NavigationStack.
    init(
        childStack: KotlinStateFlow<ChildStack<AnyObject, Destination>>,
        getTabComponentAction: @escaping (Destination) -> TabComponent?,
        tab: @escaping (TabComponent) -> TabContent,
        navigation: @escaping () -> NavigationContent
    ) {
        self.childStack = childStack
        self._tabComponent = .init(wrappedValue: TabComponentWrapper<TabComponent>())
        self.getTabComponentAction = getTabComponentAction
        self.tabContent = tab
        self.navigationContent = navigation
    }
    
    var body: some View {
        ZStack {
            navigationContent()
                .zIndex(0)
                .animation(.easeInOut, value: showTabItem)
            
            if let tabItem = tabComponent.component {
                tabContent(tabItem)
                    .zIndex(1)
                    .opacity(showTabItem ? 1 : 0)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showTabItem)
            }
        }
        .onReceive(childStack.$wrappedValue) { newValue in
            updateTabComponent(from: newValue)
        }
    }
    
    /// Обновляет состояние компонента табов на основе текущего стека навигации.
    /// - Parameter stack: Текущий стек навигации из KMP.
    private func updateTabComponent(from stack: ChildStack<AnyObject, Destination>) {
        guard
            let lastDestination = stack.items.map({ $0.instance }).last,
            let component = getTabComponentAction(lastDestination)
        else {
            showTabItem = false
            return
        }
        
        tabComponent.component = component
        showTabItem = true
    }
}

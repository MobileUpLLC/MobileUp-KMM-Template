//
//  HomeTabBar.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Combine

protocol HomeTabViewController: UIViewController {
    var homeTab: HomeTab { get }
    
    func update(component: HomeComponentChild)
}

final class HomeTabBar: UITabBarController {
    @ObservedObject var tabsStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    private var stack: [Child<AnyObject, HomeComponentChild>] { tabsStack.value.items }
    private let component: HomeComponent
    private lazy var coordinator = HomeTabBarCoordinator { [weak self] tab in self?.component.onTabSelected(tab: tab) }
    private var subscriptions: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = createTabViewControllers(coordinator)
        delegate = coordinator
        
        updateControllers()
        
        tabsStack.objectWillChange.sink { [weak self] in
            DispatchQueue.main.async {
                self?.updateControllers()
            }
        }
        .store(in: &subscriptions)
    }
    
    init(component: HomeComponent) {
        self.component = component
        tabsStack = ObservableState(component.childStack)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateControllers() {
        coordinator.syncChanges(stack, viewControllers ?? [])
        
        switch tabsStack.value.active.instance {
        case _ as HomeComponentChild.Tab1:
            selectedIndex = 0
        case _ as HomeComponentChild.Tab2:
            selectedIndex = 1
        case _ as HomeComponentChild.Tab3:
            selectedIndex = 2
        default:
            selectedIndex = 0
        }
    }
    
    private func createTabViewControllers(_ coordinator: HomeTabBarCoordinator) -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        let instances = stack.map { $0.instance }
        
        addViewController(
            viewControllers: &viewControllers,
            instances: instances,
            coordinator: coordinator,
            fakeTabBuilder: { HomeComponentChild.Tab1(component: FakeTab1Component()) }
        )
        
        addViewController(
            viewControllers: &viewControllers,
            instances: instances,
            coordinator: coordinator,
            fakeTabBuilder: { HomeComponentChild.Tab2(component: FakeTab2Component()) }
        )
        
        addViewController(
            viewControllers: &viewControllers,
            instances: instances,
            coordinator: coordinator,
            fakeTabBuilder: { HomeComponentChild.Tab3(component: FakePokemonsComponent()) }
        )
        
        return viewControllers
    }
    
    private func addViewController<T: HomeComponentChild>(
        viewControllers: inout [UIViewController],
        instances: [HomeComponentChild?],
        coordinator: HomeTabBarCoordinator,
        fakeTabBuilder: () -> T
    ) {
        if let tab = instances.compactMap({ $0 as? T }).first, let controller = getTabScreen(component: tab) {
            viewControllers.append(controller)
        } else if let controller = getTabScreen(component: fakeTabBuilder()) {
            coordinator.faked.insert(controller.homeTab)
            viewControllers.append(controller)
        }
    }
    
    private func getTabScreen<T: HomeComponentChild>(component: T) -> HomeTabViewController? {
        switch component {
        case let tabOne as HomeComponentChild.Tab1:
            return TabOneController(component: tabOne.component)
        case let tabTwo as HomeComponentChild.Tab2:
            return TabTwoController(component: tabTwo.component)
        case let pokemons as HomeComponentChild.Tab3:
            return PokemonsController(component: pokemons.component)
        default:
            return nil
        }
    }
}

class HomeTabBarCoordinator: NSObject, UITabBarControllerDelegate {
    var onTabSelected: Closure.Generic<HomeTab>
    var faked: Set<HomeTab> = []
    
    init(onTabSelected: @escaping Closure.Generic<HomeTab>) {
        self.onTabSelected = onTabSelected
    }
    
    func syncChanges(
        _ stack: [Child<AnyObject, HomeComponentChild>],
        _ viewControllers: [UIViewController]
    ) {
        let instances = stack.map { $0.instance }
        
        update(viewControllers: viewControllers, instances: instances, tab: .tab1, type: HomeComponentChild.Tab1.self)
        update(viewControllers: viewControllers, instances: instances, tab: .tab2, type: HomeComponentChild.Tab2.self)
        update(viewControllers: viewControllers, instances: instances, tab: .tab3, type: HomeComponentChild.Tab3.self)
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let controller = viewController as? HomeTabViewController else {
            print("Warning: Cannot cast tab viewController to HomeTabViewController")
            
            return false
        }
        
        onTabSelected(controller.homeTab)
        
        return false
    }
    
    private func update<T: HomeComponentChild>(
        viewControllers: [UIViewController],
        instances: [HomeComponentChild?],
        tab: HomeTab,
        type: T.Type
    ) {
        if faked.contains(tab), let component = instances.compactMap({ $0 as? T }).first {
            faked.remove(tab)
            
            viewControllers
                .compactMap({ $0 as? HomeTabViewController })
                .first(where: { $0.homeTab == tab })?
                .update(component: component)
        }
    }
}

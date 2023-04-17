//
//  HomeTabBarView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

protocol HomeTabViewController: UIViewController {
    var homeTab: HomeTab { get }
    
    func update(component: HomeComponentChild)
}

struct HomeTabBarView: UIViewControllerRepresentable {
    @ObservedObject var tabsStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    var tabScreen: (HomeComponentChild) -> HomeTabViewController?
    var onTabSelected: (HomeTab) -> Void
    
    private var stack: [Child<AnyObject, HomeComponentChild>] { tabsStack.value.items }
    
    func makeCoordinator() -> HomeTabBarCoordinator {
        HomeTabBarCoordinator { tab in
            onTabSelected(tab)
        }
    }
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = createTabViewControllers(context.coordinator)
        tabBarController.delegate = context.coordinator
        
        return tabBarController
    }
    
    func updateUIViewController(_ navigationController: UITabBarController, context: Context) {
        context.coordinator.syncChanges(stack, navigationController.viewControllers ?? [])
        
        switch tabsStack.value.active.instance {
        case _ as HomeComponentChild.Tab1:
            navigationController.selectedIndex = 0
        case _ as HomeComponentChild.Tab2:
            navigationController.selectedIndex = 1
        case _ as HomeComponentChild.Tab3:
            navigationController.selectedIndex = 2
        default:
            navigationController.selectedIndex = 0
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
        if let tab = instances.compactMap({ $0 as? T }).first, let controller = tabScreen(tab) {
            viewControllers.append(controller)
        } else if let controller = tabScreen(fakeTabBuilder()) {
            coordinator.faked.insert(controller.homeTab)
            viewControllers.append(controller)
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
            print(DeveloperService.Messages.cannotCastTab)
            
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

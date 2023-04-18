//
//  HomeTabBarView.swift
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

struct HomeTabBarView: UIViewControllerRepresentable {
    @ObservedObject var tabsStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    var tabScreen: (HomeComponentChild) -> HomeTabViewController?
    var onTabSelected: (HomeTab) -> Void
    
    func makeUIViewController(context: Context) -> HomeTabBarController {
        return HomeTabBarController(tabsStack: tabsStack, tabScreen: tabScreen, onTabSelected: onTabSelected)
    }
    
    func updateUIViewController(_ navigationController: HomeTabBarController, context: Context) {}
}

class HomeTabBarController: UITabBarController, BottomSheetPresentable {
    var transitionDelegate: BottomSheetTransitioningDelegate?
    var canBottomSheetBeDismissed: Bool { true }
    
    private var stack: [HomeComponentChild] { tabsStack.value.items.compactMap { $0.instance } }
    private let coordinator: HomeTabBarCoordinator
    private var subscriptions: [AnyCancellable] = []
    
    @ObservedObject private var tabsStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateControllers()
        
        tabsStack.objectWillChange.sink { [weak self] in
            DispatchQueue.main.async {
                self?.updateControllers()
            }
        }
        .store(in: &subscriptions)
    }
    
    init(
        tabsStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>,
        tabScreen: @escaping (HomeComponentChild) -> HomeTabViewController?,
        onTabSelected: @escaping (HomeTab) -> Void
    ) {
        self.coordinator = HomeTabBarCoordinator(tabScreen: tabScreen, onTabSelected: onTabSelected)
        self.tabsStack = tabsStack
        
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = coordinator.createTabViewControllers(stack: stack)
        delegate = coordinator
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        assertionFailure(DeveloperService.Messages.initHasNotBeenImplemented)
        
        return nil
    }
    
    private func updateControllers() {
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
}

class HomeTabBarCoordinator: NSObject, UITabBarControllerDelegate {
    var tabScreen: (HomeComponentChild) -> HomeTabViewController?
    var onTabSelected: Closure.Generic<HomeTab>
    var faked: Set<HomeTab> = []
    
    init(
        tabScreen: @escaping (HomeComponentChild) -> HomeTabViewController?,
        onTabSelected: @escaping Closure.Generic<HomeTab>
    ) {
        self.tabScreen = tabScreen
        self.onTabSelected = onTabSelected
    }
    
    func createTabViewControllers(stack: [HomeComponentChild]) -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        addViewController(
            viewControllers: &viewControllers,
            instances: stack,
            fakeTabBuilder: { HomeComponentChild.Tab1(component: FakeTab1Component()) }
        )
        
        addViewController(
            viewControllers: &viewControllers,
            instances: stack,
            fakeTabBuilder: { HomeComponentChild.Tab2(component: FakeTab2Component()) }
        )
        
        addViewController(
            viewControllers: &viewControllers,
            instances: stack,
            fakeTabBuilder: { HomeComponentChild.Tab3(component: FakePokemonsComponent()) }
        )
        
        return viewControllers
    }
    
    func syncChanges(_ stack: [HomeComponentChild], _ viewControllers: [UIViewController]) {
        update(viewControllers: viewControllers, instances: stack, tab: .tab1, type: HomeComponentChild.Tab1.self)
        update(viewControllers: viewControllers, instances: stack, tab: .tab2, type: HomeComponentChild.Tab2.self)
        update(viewControllers: viewControllers, instances: stack, tab: .tab3, type: HomeComponentChild.Tab3.self)
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
        instances: [HomeComponentChild],
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
    
    private func addViewController<T: HomeComponentChild>(
        viewControllers: inout [UIViewController],
        instances: [HomeComponentChild],
        fakeTabBuilder: () -> T
    ) {
        if let tab = instances.compactMap({ $0 as? T }).first, let controller = tabScreen(tab) {
            viewControllers.append(controller)
        } else if let controller = tabScreen(fakeTabBuilder()) {
            faked.insert(controller.homeTab)
            viewControllers.append(controller)
        }
    }
}

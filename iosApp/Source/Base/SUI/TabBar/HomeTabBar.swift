//
//  HomeTabBar.swift
//  iosApp
//
//  Created by VGrokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

protocol HomeTabViewController: UIViewController {
    var homeTab: HomeTab { get }
}

final class TabOneController: HostingController<TabOneView>, HomeTabViewController {
    var homeTab: HomeTab { .tab1 }
    
    init(component: Tab1Component) {
        super.init(rootView: TabOneView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab1_label.desc().localized(),
            image: UIImage(systemName: "1.square"),
            tag: .zero
        )
    }
}

final class TabTwoController: HostingController<TabTwoView>, HomeTabViewController {
    var homeTab: HomeTab { .tab2 }
    
    init(component: Tab2Component) {
        super.init(rootView: TabTwoView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab2_label.desc().localized(),
            image: UIImage(systemName: "2.square"),
            tag: .one
        )
    }
}

final class PokemonsController: HostingController<PokemonsView>, HomeTabViewController {
    var homeTab: HomeTab { .tab3 }
    
    init(component: PokemonsComponent) {
        super.init(rootView: PokemonsView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab3_label.desc().localized(),
            image: UIImage(systemName: "3.square"),
            tag: .two
        )
    }
}

struct HomeTabBar: UIViewControllerRepresentable {
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
        tabBarController.viewControllers = createTabViewControllers()
        tabBarController.delegate = context.coordinator
        
        return tabBarController
    }
    
    func updateUIViewController(_ navigationController: UITabBarController, context: Context) {
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
    
    private func createTabViewControllers() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        if
            let child = stack.map({ $0.instance }).first(where: { $0 is HomeComponentChild.Tab1 }),
            let tab1 = child as? HomeComponentChild.Tab1,
            let tab = tabScreen(tab1)
        {
            viewControllers.append(tab)
        } else if
            let child = stack.map({ $0.instance }).first(where: { $0 is HomeComponentChild.Tab2 }),
            let tab2 = child as? HomeComponentChild.Tab2,
            let tab = tabScreen(tab2)
        {
            viewControllers.append(tab)
        } else if
            let child = stack.map({ $0.instance }).first(where: { $0 is HomeComponentChild.Tab3 }),
            let tab3 = child as? HomeComponentChild.Tab3,
            let tab = tabScreen(tab3)
        {
            viewControllers.append(tab)
        }
        
//        for child in stack {
//            if let instance = child.instance, let tab = tabScreen(instance) {
//                viewControllers.append(tab)
//            }
//        }
        
        return viewControllers
    }
}

class HomeTabBarCoordinator: NSObject, UITabBarControllerDelegate {
    var onTabSelected: Closure.Generic<HomeTab>
    
    init(onTabSelected: @escaping Closure.Generic<HomeTab>) {
        self.onTabSelected = onTabSelected
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.tabBarItem.title ?? "")")
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        print("Should select tab with index: 0")
        
        guard let controller = viewController as? HomeTabViewController else {
            print("Warning: Cannot cast tab viewController to HomeTabViewController")
            
            return false
        }
        
        onTabSelected(controller.homeTab)
        
        return false
    }
}

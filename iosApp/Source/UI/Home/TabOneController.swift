//
//  TabOneController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class TabOneController: HostingController<TabOneView>, HomeTabViewController {
    var homeTab: HomeTab { .tab1 }
    
    private var component: Tab1Component
    
    init(component: Tab1Component) {
        self.component = component
        
        super.init(rootView: TabOneView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab1_label.desc().localized(),
            image: UIImage(systemName: "1.square"),
            tag: .zero
        )
    }
    
    func update(component: HomeComponentChild) {
        guard
            let homeChildComponent = component as? HomeComponentChild.Tab1,
            homeChildComponent.component !== self.component
        else {
            return
        }
        
        self.component = homeChildComponent.component
        rootView = TabOneView(component: homeChildComponent.component).embedded(in: self)
    }
}

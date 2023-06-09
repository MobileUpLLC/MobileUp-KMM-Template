//
//  TabTwoController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class TabTwoController: HostingController<TabTwoView>, HomeTabViewController {
    var homeTab: HomeTab { .tab2 }
    
    private var component: Tab2Component
    
    init(component: Tab2Component) {
        self.component = component
        
        super.init(rootView: TabTwoView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab2_label.desc().localized(),
            image: UIImage(systemName: "2.square"),
            tag: .one
        )
    }
    
    func update(component: HomeComponentChild) {
        guard
            let homeComponentChild = component as? HomeComponentChild.Tab2,
            homeComponentChild.component !== component
        else {
            return
        }
        
        self.component = homeComponentChild.component
        rootView = TabTwoView(component: homeComponentChild.component).embedded(in: self)
    }
}

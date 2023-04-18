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
    
    init(component: Tab1Component) {
        super.init(rootView: TabOneView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab1_label.desc().localized(),
            image: UIImage(systemName: "1.square"),
            tag: .zero
        )
    }
    
    func update(component: HomeComponentChild) {
        guard let component = component as? HomeComponentChild.Tab1 else {
            return
        }
        
        rootView = TabOneView(component: component.component).embedded(in: self)
    }
}

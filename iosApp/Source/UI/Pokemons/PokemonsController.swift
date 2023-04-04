//
//  PokemonsController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

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
    
    func update(component: HomeComponentChild) {
        guard let component = component as? HomeComponentChild.Tab3 else {
            return
        }
        
        rootView = PokemonsView(component: component.component)
    }
}

//
//  PokemonsController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class PokemonsController: StackNavigationController<PokemonsComponentChild>, HomeTabViewController {
    var homeTab: HomeTab { .tab3 }
    
    init(component: PokemonsComponent) {
        super.init(
            stackState: ObservableState(component.childStack)
        ) { child in
            switch child {
            case let pokemonsList as PokemonsComponentChildList:
                return PokemonListController(component: pokemonsList.component)
            case let pokemonsDetails as PokemonsComponentChildDetails:
                let controller = PokemonDetailsController(component: pokemonsDetails.component)
                controller.hidesBottomBarWhenPushed = true
                
                return controller
            default:
                return nil
            }
        }
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab3_label.desc().localized(),
            image: UIImage(systemName: "3.square"),
            tag: .two
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(component: HomeComponentChild) {
        guard let component = component as? HomeComponentChild.Tab3 else {
            return
        }
        
        update(stack: component.component.childStack)
    }
}

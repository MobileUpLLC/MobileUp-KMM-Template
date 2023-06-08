//
//  PokemonView.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct PokemonView: View {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, PokemonsComponentChild>>
    
    init(component: PokemonsComponent) {
        childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        StackView(
            stackState: childStack,
            childScreen: { child in
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
        )
        .ignoresSafeArea()
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonView(component: FakePokemonsComponent())
    }
}

//
//  PokemonListController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class PokemonListController: NavigatableHostingController<PokemonListView> {
    init(component: PokemonListComponent) {
        super.init(rootView: PokemonListView(component: component))
        
        navigationBarModel = NavigationBarModel(
            infoToolbarItem: .init(item: .title(MR.strings().pokemons_title.desc().localized())),
            isLargeTitle: true
        )
    }
}

struct PokemonListControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PokemonListController {
        return PokemonListController(component: FakePokemonListComponent())
    }
    
    func updateUIViewController(_ uiViewController: PokemonListController, context: Context) {}
}

struct PokemonListControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListControllerPreview()
    }
}

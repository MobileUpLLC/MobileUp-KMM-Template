//
//  PokemonDetailsController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class PokemonDetailsController: NavigatableHostingController<PokemonDetailsComponent, PokemonDetailsView> {
    init(component: PokemonDetailsComponent) {
        super.init(rootView: PokemonDetailsView(component: component))
        
//        navigationBarModel = NavigationBarModel(
//            infoToolbarItem: .init(item: .title(component.title.localized())),
//            isLargeTitle: true
//        )
    }
}

struct PokemonDetailsControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PokemonDetailsController {
        return PokemonDetailsController(component: FakePokemonDetailsComponent())
    }
    
    func updateUIViewController(_ uiViewController: PokemonDetailsController, context: Context) {}
}

struct PokemonDetailsControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsControllerPreview()
    }
}

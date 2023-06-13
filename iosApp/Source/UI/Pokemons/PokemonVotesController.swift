//
//  PokemonVotesController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

final class PokemonVotesController: HostingController<PokemonVotesView> {
    private let control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>
    
    init(control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>) {
        self.control = control
        
        super.init(rootView: PokemonVotesView(control: control))
    }
    
    deinit {
        control.dismiss()
    }
}

//
//  PokemonVotesController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 10.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class PokemonVotesController: HostingController<PokemonVotesView> {
    init(control: BottomSheetControl) {
        super.init(rootView: PokemonVotesView(control: control))
    }
}

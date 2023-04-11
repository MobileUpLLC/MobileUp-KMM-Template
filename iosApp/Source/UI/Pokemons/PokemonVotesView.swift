//
//  PokemonVotesView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 10.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct PokemonVotesView: View {
    private let control: BottomSheetControl
    @ObservedObject private var overlay: ObservableState<ChildOverlay<AnyObject, PokemonVotesComponent>>
    
    init(control: BottomSheetControl) {
        self.control = control
        
        guard let overlay = control.sheetOverlay as? CStateFlow<ChildOverlay<AnyObject, PokemonVotesComponent>> else {
            fatalError(DeveloperService.Messages.cannotCastTabOverlay)
        }
        
        self.overlay = ObservableState(overlay)
    }
    
    var body: some View {
        if let instance = overlay.value.overlay?.instance {
            InnerPokemonVotesView(component: instance)
        }
    }
}

private struct InnerPokemonVotesView: View {
    private let component: PokemonVotesComponent
    @ObservedObject private var votes: ObservableState<NSArray>
    
    init(component: PokemonVotesComponent) {
        self.component = component
        self.votes = ObservableState(component.pokemonVotes)
    }
    
    var body: some View {
        component.pokemonVotes as? [PokemonVote]
    }
}

struct InnerPokemonVotesView_Previews: PreviewProvider {
    static var previews: some View {
        InnerPokemonVotesView(component: FakePokemonVotesComponent())
    }
}

//
//  PokemonVotesView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 10.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct PokemonVotesView: View {
    private let control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>
    @ObservedObject private var overlay: ObservableState<ChildOverlay<AnyObject, PokemonVotesComponent>>
    
    init(control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>) {
        self.control = control
        self.overlay = ObservableState(control.sheetOverlay)
    }
    
    var body: some View {
        if let instance = overlay.value.overlay?.instance {
            InnerPokemonVotesView(component: instance)
                .padding(.top, 16)
        }
    }
}

private struct InnerPokemonVotesView: View {
    private let component: PokemonVotesComponent
    @ObservedObject private var votes: ObservableState<PokemonVotes>
    
    init(component: PokemonVotesComponent) {
        self.component = component
        self.votes = ObservableState(component.pokemonVotes)
    }
    
    var body: some View {
        if votes.value.votes.isEmpty {
            EmptyDataView(
                item: EmptyDataViewItem(title:  MR.strings().pokemons_votes_empty_description.desc().localized())
            )
        } else {
            ForEach(votes.value.votes, id: \.pokemonName) { vote in
                HStack(spacing: 0) {
                    Text(vote.pokemonName)
                    Spacer()
                    
                    Text(getVoteText(isPositive: vote.isPositive?.boolValue ?? true))
                        .foregroundColor(vote.isPositive?.boolValue ?? true ? .green : .red)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func getVoteText(isPositive: Bool) -> String {
        return isPositive
            ? MR.strings().pokemons_votes_like.desc().localized()
            : MR.strings().pokemons_votes_dislike.desc().localized()
    }
}

struct InnerPokemonVotesView_Previews: PreviewProvider {
    static var previews: some View {
        InnerPokemonVotesView(component: FakePokemonVotesComponent())
    }
}

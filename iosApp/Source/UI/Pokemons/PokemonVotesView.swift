//
//  PokemonVotesView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct PokemonVotesView: View {
    @ObservedObject private var childSlot: ObservableState<ChildSlot<AnyObject, PokemonVotesComponent>>
    
    init(control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>) {
        self.childSlot = ObservableState(control.sheetSlot)
    }
    
    var body: some View {
        if let component = childSlot.value.child?.instance {
            InnerPokemonVotesView(component: component)
                .padding(.top, 32)
                .padding(.bottom, 16)
        }
    }
}

private struct InnerPokemonVotesView: View {
    @ObservedObject private var votes: ObservableState<PokemonVotes>
    
    init(component: PokemonVotesComponent) {
        self.votes = ObservableState(component.pokemonVotes)
    }
    
    var body: some View {
        if votes.value.votes.isEmpty {
            EmptyDataView(
                item: EmptyDataViewItem(title:  MR.strings().pokemons_votes_empty_description.desc().localized())
            )
        } else {
            VStack(spacing: .zero) {
                ForEach(votes.value.votes, id: \.self) { vote in
                    HStack(spacing: .zero) {
                        Text(vote.pokemonName)
                        Spacer()
                        
                        Text(getVoteText(isPositive: vote.isPositive?.boolValue ?? true))
                            .foregroundColor(vote.isPositive?.boolValue ?? true ? .green : .red)
                    }
                    .padding(16)
                }
            }
            .scrollOnOverflow(verticalInsets: 48)
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

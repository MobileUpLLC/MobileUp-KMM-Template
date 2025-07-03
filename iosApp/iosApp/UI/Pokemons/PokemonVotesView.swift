//
//  PokemonVotesView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct PokemonVotesView: View {
    @StateObject @KotlinStateFlow private var childSlot: ChildSlot<AnyObject, PokemonVotesComponent>
    
    init(control: DialogControl<PokemonVotesComponentConfig, PokemonVotesComponent>) {
        self._childSlot = .init(control.dialogSlot)
    }
    
    var body: some View {
        if let component = childSlot.child?.instance {
            InnerPokemonVotesView(component: component)
                .roundedCorner(16, corners: [.topLeft, .topRight])
        }
    }
}

private struct InnerPokemonVotesView: View {
    @StateObject @KotlinStateFlow private var votes: PokemonVotes
    
    init(component: PokemonVotesComponent) {
        self._votes = .init(component.pokemonVotes)
    }
    
    var body: some View {
        if votes.votes.isEmpty {
            EmptyDataView(
                item: EmptyDataViewItem(title:  MR.strings().pokemons_votes_empty_description.desc().localized())
            )
        } else {
            VStack(spacing: .zero) {
                ForEach(votes.votes, id: \.self) { vote in
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
            .padding(.top, 32)
            .padding(.bottom, 16)
            .background(.background)
            .roundedCorner(16, corners: [.topLeft, .topRight])
        }
    }
    
    private func getVoteText(isPositive: Bool) -> String {
        return isPositive
            ? MR.strings().pokemons_votes_like.desc().localized()
            : MR.strings().pokemons_votes_dislike.desc().localized()
    }
}

#Preview {
    InnerPokemonVotesView(component: FakePokemonVotesComponent())
}

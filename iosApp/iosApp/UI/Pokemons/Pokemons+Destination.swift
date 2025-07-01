//
//  Pokemons+Destination.swift
//  iosApp
//
//  Created by kursor on 30.06.2025.
//

import SwiftUI

extension Skie.Shared.PokemonsComponent.Child.__Sealed: @unchecked @retroactive Sendable, Destinationable {
    @MainActor @ViewBuilder
    func destination(for item: Self) -> some View {
        switch item {
        case .list(let value):
            PokemonListView(component: value.component)
        case .details(let value):
            PokemonDetailsView(component: value.component)
        }
    }
}

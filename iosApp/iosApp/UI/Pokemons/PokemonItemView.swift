//
//  PokemonItemView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

struct PokemonItemView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            AsyncImageView(imageLink: "https://raw.githubusercontent.com/" +
                           "PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/" +
                           "\(pokemon.id.value).png")
                .frame(width: 60, height: 60)
            Text(pokemon.name)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.1))
                .padding(.top, 24)
        }
    }
}

#Preview {
    PokemonItemView(pokemon: Pokemon(id: .init(value: "1"), name: "Bulbasaur"))
        .frame(width: 120)
}

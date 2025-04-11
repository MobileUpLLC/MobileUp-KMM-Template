//
//  PokemonTypesView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

struct PokemonTypesView: View {
    let types: [PokemonType]
    let selectedTypeId: PokemonTypeId
    let onTypeClick: Closure.Generic<PokemonTypeId>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .eight) {
                ForEach(types, id: \.id) { type in
                    PokemonTypeView(
                        type: type,
                        isSelected: type.id == selectedTypeId,
                        onTypeClick: onTypeClick
                    )
                }
            }
            .padding(.vertical, .eight)
            .padding(.horizontal, 16)
        }
    }
}

private struct PokemonTypeView: View {
    let type: PokemonType
    let isSelected: Bool
    let onTypeClick: Closure.Generic<PokemonTypeId>
    
    var body: some View {
        Text(type.name)
            .fontWeight(.bold)
            .foregroundColor(isSelected ? .white : type.color.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? type.color.color : .clear)
            .cornerRadius(16)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(type.color.color, lineWidth: 2)
            }
            .onTapGesture {
                if isSelected == false {
                    onTypeClick(type.id)
                }
            }
    }
}

#Preview {
    let fire = PokemonType(id: .init(value: "10"), name: "Fire")
    let water = PokemonType(id: .init(value: "11"), name: "Water")
    let electric = PokemonType(id: .init(value: "13"), name: "Electric")
    let grass = PokemonType(id: .init(value: "12"), name: "Grass")
    let poison = PokemonType(id: .init(value: "4"), name: "Poison")
    let types: [PokemonType] = [ fire, water, electric, grass, poison]
    PokemonTypesView(
        types: types,
        selectedTypeId: .init(value: "10"),
        onTypeClick: { _ in }
    )
}

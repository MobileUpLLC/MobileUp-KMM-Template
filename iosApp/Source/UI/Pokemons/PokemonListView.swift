import SwiftUI

struct PokemonListView: View {
    @ObservedObject private var pokemonsState: ObservableState<LoadableState<NSArray>>
    @ObservedObject private var types: ObservableState<NSArray>
    @ObservedObject private var selectedTypeId: ObservableState<PokemonTypeId>
    
    private let component: PokemonListComponent

    init(component: PokemonListComponent) {
        self.component = component
        self.pokemonsState = ObservableState(component.pokemonsState)
        self.types = ObservableState(component.types)
        self.selectedTypeId = ObservableState(component.selectedTypeId)
    }
    
    var body: some View {
        PokemonsContentView(
            pokemons: (pokemonsState.value.data as? [Pokemon]) ?? [],
            types: (types.value as? [PokemonType]) ?? [],
            selectedTypeId: selectedTypeId.value,
            onPokemonClick: { id in component.onPokemonClick(pokemonId: id) },
            onTypeClick: { id in component.onTypeClick(typeId: id) }
        )
        .loadableWithError(
            loadableState: pokemonsState,
            onRefresh: { component.onRefresh() },
            onRetryClick: { component.onRetryClick() }
        )
    }
}

private struct PokemonsContentView: View {
    let pokemons: [Pokemon]
    let types: [PokemonType]
    let selectedTypeId: PokemonTypeId
    let onPokemonClick: Closure.Generic<PokemonId>
    let onTypeClick: Closure.Generic<PokemonTypeId>
    
    var body: some View {
        ScrollView {
            PokemonTypesView(
                types: types,
                selectedTypeId: selectedTypeId,
                onTypeClick: onTypeClick
            )
            
            Spacer()
            
            ForEach(pokemons, id: \.id) { pokemon in
                PokemonCellView(pokemon: pokemon)
                    .onTapGesture {
                        onPokemonClick(pokemon.id)
                    }
                
                Divider()
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct PokemonTypesView: View {
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
            .foregroundColor(isSelected ? .white : .black)
            .padding(.horizontal, 16)
            .padding(.vertical, .nine)
            .background(isSelected ? .blue : .clear)
            .cornerRadius(16)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.blue, lineWidth: .one)
            }
            .shadow(color: .gray.opacity(0.2), radius: .three, y: .two)
            .onTapGesture {
                if isSelected == false {
                    onTypeClick(type.id)
                }
            }
    }
}

private struct PokemonCellView: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(alignment: .center) {
            Text(pokemon.name)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .contentShape(Rectangle())
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(component: FakePokemonListComponent())
    }
}

import SwiftUI

struct PokemonListView: View {
    @StateObject @KotlinStateFlow private var pokemonsState: LoadableState<NSArray>
    @StateObject @KotlinStateFlow private var types: [PokemonType]
    @StateObject @KotlinStateFlow private var selectedTypeId: PokemonTypeId
    
    private let component: PokemonListComponent
    
    init(component: PokemonListComponent) {
        self.component = component
        self._pokemonsState = .init(component.pokemonsState)
        self._types = .init(component.types)
        self._selectedTypeId = .init(component.selectedTypeId)
    }
    
    var body: some View {
        PokemonsContentView(
            pokemons: (pokemonsState.data as? [Pokemon]) ?? [],
            types: types,
            selectedTypeId: selectedTypeId,
            onPokemonClick: { id in component.onPokemonClick(pokemonId: id) },
            onTypeClick: { id in component.onTypeClick(typeId: id) }
        )
        .loadableWithError(
            loadableState: _pokemonsState.wrappedValue,
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
    
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 120, maximum: .infinity)),
        GridItem(.flexible(minimum: 120, maximum: .infinity)),
        GridItem(.flexible(minimum: 120, maximum: .infinity))
    ]
    
    var body: some View {
        ScrollView {
            PokemonTypesView(
                types: types,
                selectedTypeId: selectedTypeId,
                onTypeClick: onTypeClick
            )
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(pokemons.sorted(by: { $0.name < $1.name }), id: \.id) { pokemon in
                    PokemonItemView(pokemon: pokemon)
                        .onTapGesture {
                            onPokemonClick(pokemon.id)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListView(component: FakePokemonListComponent())
            .navigationTitle("Pokemons")
    }
}

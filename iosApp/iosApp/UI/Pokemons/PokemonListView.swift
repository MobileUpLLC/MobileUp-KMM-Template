import SwiftUI

struct PokemonListView: View {
    @ObservedObject private var pokemonsState: ObservableState<LoadableState<NSArray>>
    @ObservedObject private var types: ObservableState<[PokemonType]>
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
            types: types.value,
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

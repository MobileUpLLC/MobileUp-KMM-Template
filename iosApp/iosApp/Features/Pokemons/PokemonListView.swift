import SwiftUI
import shared

struct PokemonListView: View {
    
    let component: PokemonListComponent
    
    @ObservedObject private var pokemonsState: ObservableState<LoadableState<NSArray>> // TODO: не получилось объявить ObservableState<LoadableState<[Pokemon]>>. Как это обойти?
    
    init(component: PokemonListComponent) {
        self.component = component
        self.pokemonsState = ObservableState(component.pokemonsState)
    }
    
    // TODO: не сделана поддержка pull to refresh
    // TODO: не сделано переключение типов покемонов. См как это выглядит на Android.
    var body: some View {
        let state = pokemonsState.value
        
        // TODO: для кода ниже можно сделать универсальный компонент LceView. См примеры LceWidget и SwipeRefreshLceWidget в Android-реализации.
        if let data = state.data {
           PokemonsList(pokemons: data as! [Pokemon]) // TODO: избавиться от force cast
        } else if(state.loading) {
           ProgressView()
        } else if let error = state.error {
            Text(error.localized())
        }
    }
    
    @ViewBuilder private func PokemonsList(pokemons: [Pokemon]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(pokemons) { pokemon in
                    PokemonCellView(pokemon: pokemon)
                        .onTapGesture {
                            component.onPokemonClick(pokemonId: pokemon.id)
                        }
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder private func PokemonCellView(pokemon: Pokemon) -> some View {
        HStack(alignment: .center) {
            Text(pokemon.name)
            Spacer()
        }
        .padding(.leading)
        .frame(maxWidth: .infinity, minHeight: 50)
        .contentShape(Rectangle())
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(component: FakePokemonListComponent())
    }
}

extension Pokemon: Identifiable {} // TODO: так правильно делать? Это нужно, чтоб ForEach работал. Свойство id у Pokemon объявлено в Kotlin-е

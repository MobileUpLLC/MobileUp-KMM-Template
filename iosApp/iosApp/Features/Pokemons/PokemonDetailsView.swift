import SwiftUI
import shared

struct PokemonDetailsView: View {
    
    private let component: PokemonDetailsComponent
    
    @ObservedObject private var pokemonState: ObservableState<LoadableState<DetailedPokemon>>
    
    init(component: PokemonDetailsComponent) {
        self.component = component
        self.pokemonState = ObservableState(component.pokemonState)
    }
    
    var body: some View {
        let state = pokemonState.value
        
        // TODO: можно сделать универсальный компонент - LceView.
        if let data = state.data {
            if(state.loading) {
                Text("refreshing") // TODO: придумать, как отобразить обновление данных. См как это выглядит на Android
            }
            PokemonDetailsView(pokemon: data)
        } else if(state.loading) {
           ProgressView()
        } else if let error = state.error {
            Text(error.localized())
        }
        
    }
    
    @ViewBuilder private func PokemonDetailsView(pokemon: DetailedPokemon) -> some View {
        VStack(alignment: .leading) {
            Text(pokemon.name)
                .font(.largeTitle)
            
            // TODO: сделать нормальный плейсхолдер и чтоб верстка не прыгала
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Text("Грузим пикчу покемона...")
            }
            
            Text(MR.strings().pokemons_types.desc().localized())
                .font(.body)
            HStack(spacing: 10) {
                ForEach(pokemon.types, id: \.id) { type in
                    PokemonTypeItem(pokemonType: type)
                }
            }
            
            Text(MR.strings().pokemons_height.format(args_: [pokemon.height]).localized())
                .font(.body)
                .padding(.top, 10)
            Text(MR.strings().pokemons_weight.format(args_: [pokemon.weight]).localized())
                .font(.body)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder private func PokemonTypeItem(pokemonType: PokemonType) -> some View {
        Text(pokemonType.name)
            .padding()
            .background(Color.yellow.opacity(0.5))
            .cornerRadius(10)
    }
}

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsView(component: FakePokemonDetailsComponent())
    }
}

extension PokemonType: Identifiable {} // TODO: так правильно делать? Это нужно, чтоб ForEach работал. Свойство id у PokemonType объявлено в Kotlin-е

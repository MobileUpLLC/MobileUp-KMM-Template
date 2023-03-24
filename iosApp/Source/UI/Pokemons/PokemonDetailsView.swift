import SwiftUI

struct PokemonDetailsView: View {
    private let component: PokemonDetailsComponent
    
    @ObservedObject private var pokemonState: ObservableState<LoadableState<DetailedPokemon>>
    
    init(component: PokemonDetailsComponent) {
        self.component = component
        self.pokemonState = ObservableState(component.pokemonState)
    }
    
    var body: some View {
        RefreshingLoadingView(
            loadableState: pokemonState,
            content: { pokemon in
                return PokemonDetailsBodyView(pokemon: pokemon)
            },
            onRefresh: { component.onRefresh() }
        )
    }
}

private struct PokemonDetailsBodyView: View {
    let pokemon: DetailedPokemon
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImageView(
                    imageLink: pokemon.imageUrl,
                    placeholderColor: .clear
                )
                .aspectRatio(1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
                
                Group {
                    Text(MR.strings().pokemons_types.desc().localized())
                        .font(.body)
                        .padding(.top, 8)
                    
                    HStack(spacing: 10) {
                        ForEach(pokemon.types, id: \.id) { type in
                            PokemonTypeItem(pokemonType: type)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Text(MR.strings().pokemons_height.format(args_: [pokemon.height]).localized())
                        .font(.body)
                        .padding(.top, 10)
                    
                    Text(MR.strings().pokemons_weight.format(args_: [pokemon.weight]).localized())
                        .font(.body)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PokemonTypeItem: View {
    let pokemonType: PokemonType
    
    var body: some View {
        Text(pokemonType.name)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .frame(height: 32)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.5), radius: 7, y: 3)
    }
}

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsView(component: FakePokemonDetailsComponent())
    }
}

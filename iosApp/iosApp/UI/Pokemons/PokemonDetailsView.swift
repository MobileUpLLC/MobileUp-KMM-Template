import SwiftUI

struct PokemonDetailsView: View {
    @StateObject @KotlinStateFlow private var pokemonState: LoadableState<DetailedPokemon>
    @StateObject @KotlinStateFlow private var voteState: PokemonVoteState
    @StateObject @KotlinStateFlow private var dialog: ChildSlot<AnyObject, PokemonVoteDialogComponent>
    
    private let component: PokemonDetailsComponent
    
    init(component: PokemonDetailsComponent) {
        self.component = component
        self._pokemonState = .init(component.pokemonState)
        self._voteState = .init(component.pokemonVoteState)
        self._dialog = .init(component.dialogControl.dialogSlot)
    }
    
    var body: some View {
        UnwrapView(pokemonState.data) { pokemon in
            PokemonDetailsDescriptionView(
                pokemon: pokemon,
                voteState: voteState,
                dialogComponent: dialog.child?.instance,
                onVoteClick: { component.onVoteClick() }
            )
            .safeAreaInset(edge: .top) {
                AsyncImageView(
                    imageLink: pokemon.imageUrl,
                    placeholderColor: .clear
                )
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(32)
                .offset(y: 100)
            }
            .background(pokemon.types.first?.color.color ?? .gray)
        }
        .navigationTitle(pokemonState.data?.name ?? " ")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    component.onVoteClick()
                } label: {
                    getImageVoteButton(voteState)
                }
                .tint(.primary)
            }
        }
        .loadableWithError(
            loadableState: _pokemonState.wrappedValue,
            onRefresh: { component.onRefresh() },
            onRetryClick: { component.onRetryClick() }
        )
        .alertChild(
            getAlertTitle(),
            childSlot: dialog,
            actions: { DialogButtons(dialogComponent: dialog.child?.instance) },
            message: { Text(getAlertMessage()) }
        )
    }
    
    private func getAlertTitle() -> String {
        let pokemonName = dialog.child?.instance.dialogData.value.pokemonName ?? .empty
        
        return MR.strings().pokemons_dialog_title.format(args: [pokemonName]).localized()
    }
    
    private func getAlertMessage() -> String {
        let pokemonName = dialog.child?.instance.dialogData.value.pokemonName ?? .empty
        let types = dialog.child?.instance.dialogData.value.formatPokemonTypes ?? .empty
        
        return MR.strings().pokemons_dialog_description.format(args: [pokemonName, types]).localized()
    }
    
    private func getImageVoteButton(_ voteState: PokemonVoteState) -> Image {
        switch voteState {
        case .negative:
            return Image(systemName: "hand.thumbsdown.fill")
        case .positive:
            return Image(systemName: "hand.thumbsup.fill")
        case .none:
            return Image(systemName: "hand.thumbsup")
        }
    }
}

private struct PokemonDetailsDescriptionView: View {
    let pokemon: DetailedPokemon
    let voteState: PokemonVoteState
    let dialogComponent: PokemonVoteDialogComponent?
    let onVoteClick: Closure.Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 40)
            
            HStack {
                ForEach(pokemon.types, id: \.id) { type in
                    PokemonTypeItem(pokemonType: type, color: type.color.color)
                }
            }
            
            HStack(spacing: 16) {
                PokemonPropertyView(property: "Weight", icon: Image(systemName: "scalemass"), value: pokemon.weight.formatted() + " kg")
                PokemonPropertyView(property: "Height", icon: Image(systemName: "arrow.up.and.down.square"), value: pokemon.height.formatted() + " m")
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.bottom, 50)
        .background(.white)
        .roundedCorner(20, corners: [.topLeft, .topRight])
    }
}

private struct PokemonTypeItem: View {
    let pokemonType: PokemonType
    let color: Color
    
    var body: some View {
        Text(pokemonType.name)
            .font(.headline)
            .foregroundStyle(color)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .stroke(color, lineWidth: 2)
            }
            .padding(1)
    }
}

private struct DialogButtons: View {
    let dialogComponent: PokemonVoteDialogComponent?
    
    var body: some View {
        Group {
            Button(MR.strings().pokemons_dialog_vote_positive.desc().localized(), role: .none) {
                dialogComponent?.votePositive()
            }
            
            Button(MR.strings().pokemons_dialog_vote_negative.desc().localized(), role: .none) {
                dialogComponent?.voteNegative()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailsView(component: FakePokemonDetailsComponent())
    }
}

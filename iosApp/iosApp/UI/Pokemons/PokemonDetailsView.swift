import SwiftUI

struct PokemonDetailsView: View {
    @ObservedObject private var pokemonState: ObservableState<LoadableState<DetailedPokemon>>
    @ObservedObject private var voteState: ObservableState<PokemonVoteState>
    @ObservedObject private var dialog: ObservableState<ChildSlot<AnyObject, PokemonVoteDialogComponent>>
    
    private let component: PokemonDetailsComponent
    
    init(component: PokemonDetailsComponent) {
        self.component = component
        self.pokemonState = ObservableState(component.pokemonState)
        self.voteState = ObservableState(component.pokemonVoteState)
        self.dialog = ObservableState(component.dialogControl.dialogSlot)
    }
    
    var body: some View {
        UnwrapView(pokemonState.value.data) { pokemon in
            PokemonDetailsDescriptionView(
                pokemon: pokemon,
                voteState: voteState.value,
                dialogComponent: dialog.value.child?.instance,
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
            .navigationTitle(pokemon.name)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    component.onVoteClick()
                } label: {
                    getImageVoteButton(voteState.value)
                }
                .tint(.primary)
            }
        }
        .loadableWithError(
            loadableState: pokemonState,
            onRefresh: { component.onRefresh() },
            onRetryClick: { component.onRetryClick() }
        )
        .alertChild(
            getAlertTitle(),
            childSlot: dialog.value,
            actions: { DialogButtons(dialogComponent: dialog.value.child?.instance) },
            message: { Text(getAlertMessage()) }
        )
    }
    
    private func getAlertTitle() -> String {
        let pokemonName = dialog.value.child?.instance.dialogData.value.pokemonName ?? .empty
        
        return MR.strings().pokemons_dialog_title.format(args: [pokemonName]).localized()
    }
    
    private func getAlertMessage() -> String {
        let pokemonName = dialog.value.child?.instance.dialogData.value.pokemonName ?? .empty
        let types = dialog.value.child?.instance.dialogData.value.formatPokemonTypes ?? .empty
        
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

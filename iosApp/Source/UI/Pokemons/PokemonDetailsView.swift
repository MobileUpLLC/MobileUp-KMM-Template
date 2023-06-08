import SwiftUI

struct PokemonDetailsView: View {
    private let component: PokemonDetailsComponent
    
    @ObservedObject private var pokemonState: ObservableState<LoadableState<DetailedPokemon>>
    @ObservedObject private var voteState: ObservableState<PokemonVoteState>
    @ObservedObject private var dialog: ObservableState<ChildOverlay<AnyObject, PokemonVoteDialogComponent>>
    
    init(component: PokemonDetailsComponent) {
        self.component = component
        self.pokemonState = ObservableState(component.pokemonState)
        self.voteState = ObservableState(component.pokemonVoteState)
        self.dialog = ObservableState(component.dialogControl.dialogOverlay)
    }
    
    var body: some View {
        Group {
            if let pokemon = pokemonState.value.data {
                PokemonDetailsBodyView(
                    pokemon: pokemon,
                    voteState: voteState.value,
                    dialogComponent: dialog.value.overlay?.instance,
                    onVoteClick: { component.onVoteClick() }
                )
            }
        }
        .loadableWithError(
            loadableState: pokemonState,
            onRefresh: { component.onRefresh() },
            onRetryClick: { component.onRetryClick() }
        )
    }
}

private struct PokemonDetailsBodyView: View {
    let pokemon: DetailedPokemon
    let voteState: PokemonVoteState
    let dialogComponent: PokemonVoteDialogComponent?
    let onVoteClick: Closure.Void
    
    @State private var isDialogPresented = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImageView(
                    imageLink: pokemon.imageUrl,
                    placeholderColor: .clear
                )
                .aspectRatio(1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32)
                
                PokemonDetailsDescriptionView(
                    isDialogPresented: $isDialogPresented,
                    pokemon: pokemon,
                    voteState: voteState,
                    dialogComponent: dialogComponent,
                    onVoteClick: onVoteClick
                )
                
                Spacer()
            }
            .onChange(of: isDialogPresented) { [oldValue = isDialogPresented] newValue in
                if oldValue == true && newValue == false {
                    dialogComponent?.dismiss()
                }
            }
        }
        .alert(
            getAlertTitle(),
            isPresented: $isDialogPresented,
            actions: { DialogButtons(dialogComponent: dialogComponent) },
            message: { Text(getAlertMessage()) }
        )
    }
    
    private func getAlertTitle() -> String {
        let pokemonName = dialogComponent?.dialogData.value.pokemonName ?? .empty
        
        return MR.strings().pokemons_dialog_title.format(args_: [pokemonName]).localized()
    }
    
    private func getAlertMessage() -> String {
        let pokemonName = dialogComponent?.dialogData.value.pokemonName ?? .empty
        let types = dialogComponent?.dialogData.value.formatPokemonTypes ?? .empty
        
        return MR.strings().pokemons_dialog_description.format(args_: [pokemonName, types]).localized()
    }
}

private struct PokemonDetailsDescriptionView: View {
    @Binding var isDialogPresented: Bool
    
    let pokemon: DetailedPokemon
    let voteState: PokemonVoteState
    let dialogComponent: PokemonVoteDialogComponent?
    let onVoteClick: Closure.Void
    
    var body: some View {
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
            
            HStack {
                Spacer()
                
                Button(MR.strings().pokemons_vote.desc().localized()) {
                    onVoteClick()
                    
                    isDialogPresented = true
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .foregroundColor(getButtonForegroundColor())
                .background(getButtonBackgroundColor())
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.2), radius: 3, y: 2)
                .animation(.easeIn, value: voteState)
                
                Spacer()
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
    }
    
    private func getButtonForegroundColor() -> Color {
        switch voteState {
        case .negative:
            return .white
        case .positive:
            return .black
        case .none:
            return .white
        default:
            return .white
        }
    }
    
    private func getButtonBackgroundColor() -> Color {
        switch voteState {
        case .negative:
            return .red
        case .positive:
            return .green
        case .none:
            return .blue
        default:
            return .blue
        }
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

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsView(component: FakePokemonDetailsComponent())
    }
}

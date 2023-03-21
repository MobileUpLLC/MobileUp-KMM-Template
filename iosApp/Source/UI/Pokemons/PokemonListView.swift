import SwiftUI

struct SwiftPokemonType: Identifiable, Equatable {
    let id: String
    let name: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

// Не получилось объявить ObservableState<LoadableState<[Pokemon]>>. Как это обойти?
// Ответ: Массивы в свифте - структуры, LoadableState требует класс как подтип
// TODO: Android
// Решение: Создать в котлине класс ListContainer с единственным полем values: List<T>, где T должен быть Pokemon
// https://github.com/hhru/kotlin-swift-interopedia/blob/main/docs/types/Collections%20with%20custom%20types%20data.md
struct PokemonListView: View {
    let component: PokemonListComponent

    @ObservedObject private var pokemonsState: ObservableState<LoadableState<NSArray>>
    @ObservedObject private var selectedTypeId: ObservableState<AnyObject>
    
    private var types: [SwiftPokemonType] {
        return (component.types.value as? [PokemonType])?.compactMap { $0.toSwiftPokemonType() } ?? []
    }
    
    init(component: PokemonListComponent) {
        self.component = component
        self.pokemonsState = ObservableState(component.pokemonsState)
        self.selectedTypeId = ObservableState(component.selectedTypeId)
    }
    
    var body: some View {
        RefreshingLoadingView(
            loadableState: pokemonsState,
            content: getContentView(),
            onRefresh: { component.onRefresh() }
        )
        .navigationTitle("Pokemons")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func getContentView() -> (some View)? {
        guard let pokemons = pokemonsState.value.data as? [Pokemon] else {
            return Optional<AnyView>.none
        }
        
        return AnyView(
            PokemonsContentView(
                pokemons: pokemons,
                types: types,
                selectedTypeId: getSelectedTypeId(),
                onPokemonClick: component.onPokemonClick(pokemonId:),
                onTypeClick: { id in component.onTypeClick(typeId: id) }
            )
        )
    }
    
    private func getSelectedTypeId() -> String {
        // TODO: Android
        // value class не переносятся в swift, из-за этого невозможно обращаться к id, то есть не понятно,
        // к чему приводить, h файла нет, String не работает
        // https://github.com/hhru/kotlin-swift-interopedia/blob/main/docs/classes/Value%20class.md
        guard let typeId = selectedTypeId.value as? String else {
            return .empty
        }
        
        return typeId
    }
}

private struct PokemonsContentView: View {
    let pokemons: [Pokemon]
    let types: [SwiftPokemonType]
    let selectedTypeId: String
    let onPokemonClick: (Any) -> Void
    let onTypeClick: (String) -> Void
    
    var body: some View {
        ScrollView {
            PokemonTypesView(
                types: types,
                selectedType: getSelectedPokemonType(),
                onTypeClick: onTypeClick
            )
            
            Spacer()
            
            ForEach(pokemons) { pokemon in
                PokemonCellView(pokemon: pokemon)
                    .onTapGesture {
                        onPokemonClick(pokemon.id)
                    }
                
                Divider()
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func getSelectedPokemonType() -> SwiftPokemonType {
        return types.first(where: { $0.id == selectedTypeId }) ?? PokemonType.companion.Fire.toSwiftPokemonType()
    }
}

private struct PokemonTypesView: View {
    let types: [SwiftPokemonType]
    let selectedType: SwiftPokemonType
    let onTypeClick: Closure.String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(types) { type in
                    PokemonTypeView(type: type, isSelected: type == selectedType, onTypeClick: onTypeClick)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
    }
}

private struct PokemonTypeView: View {
    let type: SwiftPokemonType
    let isSelected: Bool
    let onTypeClick: Closure.String
    
    var body: some View {
        VStack {
            Text(type.name)
                .foregroundColor(isSelected ? .white : .black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(isSelected ? .blue : .clear)
        .cornerRadius(16)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.blue, lineWidth: 1)
        }
        .shadow(color: .gray.opacity(0.2), radius: 3, y: 2)
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

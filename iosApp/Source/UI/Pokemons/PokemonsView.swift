import SwiftUI

struct PokemonsView: View {
    let component: PokemonsComponent
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, PokemonsComponentChild>>
    
    init(component: PokemonsComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        StackView(
            stackState: childStack,
            childScreen: { child in
                switch child {
                case let pokemonsList as PokemonsComponentChildList:
                    return PokemonListController(component: pokemonsList.component)
                case let pokemonsDetails as PokemonsComponentChildDetails:
                    return PokemonDetailsController(component: pokemonsDetails.component)
                default:
                    return nil
                }
            }
        )
        .ignoresSafeArea()
    }
}

struct PokemonsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonsView(component: FakePokemonsComponent())
    }
}

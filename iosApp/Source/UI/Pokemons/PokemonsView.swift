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
            getNavigationBarItem: { component in
                if component is PokemonsComponentChildList {
                    return NavigationBarItem(
                        title: MR.strings().pokemons_title.desc().localized(),
                        mode: .always
                    )
                } else if let component = (component as? PokemonsComponentChildDetails)?.component {
                    return NavigationBarItem(
                        title: component.title.localized(),
                        mode: .never
                    )
                }
                
                return .default
            },
            childContent: { c in
                if let component = (c as? PokemonsComponentChildList)?.component {
                    PokemonListView(component: component)
                } else if let component = (c as? PokemonsComponentChildDetails)?.component {
                    PokemonDetailsView(component: component)
                }
            }
        )
    }
}

struct PokemonsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonsView(component: FakePokemonsComponent())
    }
}

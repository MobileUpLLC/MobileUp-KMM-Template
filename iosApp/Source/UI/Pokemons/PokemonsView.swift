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
            childContent: { c in
                if let component = (c as? PokemonsComponentChild.List)?.component {
                    PokemonListView(component: component)
                } else if let component = (c as? PokemonsComponentChild.Details)?.component {
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

import SwiftUI
import shared

struct RootView: View {
    private let component: RootComponent
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    
    init(component: RootComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        // TODO: как лучше сделать вложенную навигацию? На iOS 15 задваивается title из-за того, что используются вложенные StackView
        // Может, вообще не использовать тут StackView?
        StackView(
            stackState: childStack,
            childContent: { c in
                if let component = (c as? RootComponentChild.Pokemons)?.component {
                    PokemonsView(component: component)
                }
            }
        )
        
        // TODO: добавить отображение ошибок из MessageComponent. На Android они отображаются в виде снекбаров поверх основного содержимого.
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(component: FakeRootComponent())
    }
}

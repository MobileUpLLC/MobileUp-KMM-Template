import SwiftUI

struct RootView: View {
    private let component: RootComponent
    
    // TODO: iOS Попытаться найти способ не делать так много дженериков (ObservableState хотелось бы убрать)
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    
    init(component: RootComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        // TODO: iOS Проработать навигацию, при сложной навигации могут возникнуть проблемы
        if let child = component.childStack.value.items.first?.instance as? RootComponentChild.Pokemons {
            PokemonsView(component: child.component)
        } else {
            EmptyView()
        }
        
        // TODO: iOS добавить отображение ошибок из MessageComponent.
        // На Android они отображаются в виде снекбаров поверх основного содержимого.
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(component: FakeRootComponent())
    }
}

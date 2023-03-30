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
        ZStack {
            switch component.childStack.value.items.first?.instance {
            case let flowOne as RootComponentChild.Flow1:
                FlowOneView(component: flowOne.component)
            case let flowTwo as RootComponentChild.Flow2:
                FlowTwoView(component: flowTwo.component)
            case let home as RootComponentChild.Home:
                HomeView(component: home.component)
            default:
                EmptyView()
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: component.childStack.value.items.first?.instance)
        
        // TODO: iOS добавить отображение ошибок из MessageComponent.
        // На Android они отображаются в виде снекбаров поверх основного содержимого.
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(component: FakeRootComponent())
    }
}

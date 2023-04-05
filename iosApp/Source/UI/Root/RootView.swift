import SwiftUI

struct RootView: View {
    private let component: RootComponent
    private let rootHolder: RootHolder
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    
    init(component: RootComponent, rootHolder: RootHolder) {
        self.component = component
        self.rootHolder = rootHolder
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        ZStack {
            ForEach(childStack.value.items, id: \.instance) { child in
                switch child.instance {
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
        }
        .onAppear { rootHolder.onViewAppear() }
        .onDisappear { rootHolder.onViewDisappear() }
        .transition(.opacity)
        .animation(.easeInOut, value: component.childStack.value.items)
        .ignoresSafeArea()
        
        // TODO: iOS добавить отображение ошибок из MessageComponent.
        // На Android они отображаются в виде снекбаров поверх основного содержимого.
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(component: FakeRootComponent(), rootHolder: RootHolder())
    }
}

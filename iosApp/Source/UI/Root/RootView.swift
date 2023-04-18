import SwiftUI

struct RootView: View {
    private let component: RootComponent
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    @ObservedObject private var message: NullableObservableState<Message>
    
    init(component: RootComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
        self.message = NullableObservableState(component.messageComponent.visibleMessage)
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
        .transition(.opacity)
        .animation(.easeInOut, value: component.childStack.value.items)
        .ignoresSafeArea()
        
        // TODO: iOS add error view from MessageComponent.
        // In Android it is implemented via snack bars over the main content
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(component: FakeRootComponent())
    }
}

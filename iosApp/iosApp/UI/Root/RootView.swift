import SwiftUI

struct RootView: View, TreeNavigation {
    @StateObject var navigationModel = RootNavigationModel()
    @ObservedObject var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    @ObservedObject private var message: ObservableOptionalState<Message>
    
    private let component: RootComponent
    
    init(component: RootComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
        self.message = ObservableOptionalState(component.messageComponent.visibleMessage)
    }
    
    var body: some View {
        let zIndex: Double = navigationModel.showHome ? 1 : 0
        ZStack {
            let home = navigationModel.tabComponent as? RootComponentChild.Home ?? RootComponentChild.Home(component: FakeHomeComponent())
            HomeView(component: home.component)
                .zIndex(zIndex)
            
            NavigationStack(path: $navigationModel.navigationPath) {
                rootView
                    .treeNavigation(childStack: childStack, navigationModel: navigationModel, destination: destination(for:))
            }
            .setRootTreeNavigation(childStack: childStack, navigationModel: navigationModel)
            .zIndex(0)
        }
        .toast(message: $message.value, onAction: component.messageComponent.onActionClick)
        .environmentObject(navigationModel)
        .overlay(alignment: .bottomTrailing) {
            HStack {
                Button {
                    let path = navigationModel.flatPath.pathDescription()
                    print("🐦‍🔥 Swift Root Stack" + "\n", path, "\n", navigationModel.navigationPath.pathDescription)
                } label: {
                    Image(systemName: "circle.fill")
                        .tint(.orange)
                }
                
                Button {
                    let path = childStack.value.items.map({ $0.instance as AnyHashable }).pathDescription()
                    print("🤖 KMM Root Stack" + "\n", path)
                } label: {
                    Image(systemName: "circle.fill")
                        .tint(.green)
                }
            }
            .padding(20)
        }
    }
    
    @ViewBuilder
    func destination(for item: RootComponentChild) -> some View {
        switch onEnum(of: item) {
        case .flow1(let child):
            FlowOneView(component: child.component)
        case .flow2(let child):
            FlowTwoView(component: child.component)
        case .home(let child):
            HomeView(component: child.component)
        }
    }
}

#Preview {
    RootView(component: FakeRootComponent())
        .environmentObject(ToastRouter())
}

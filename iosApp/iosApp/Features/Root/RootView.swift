import SwiftUI
import shared

struct RootView: View {
    private let rootComponent: RootComponent
    
    init(_ rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
    
    var body: some View {
        Text("Root")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(FakeRootComponent())
    }
}

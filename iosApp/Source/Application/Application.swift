import SwiftUI

@main
struct Application: App {
    @StateObject private var rootHolder = RootHolder()
        
    var body: some Scene {
        WindowGroup {
            RootView(component: rootHolder.rootComponent)
                .onAppear { rootHolder.onViewAppear() }
                .onDisappear { rootHolder.onViewDisappear() }
        }
    }
}

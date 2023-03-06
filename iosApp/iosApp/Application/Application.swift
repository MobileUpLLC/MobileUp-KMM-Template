import SwiftUI
import shared

@main
struct Application: App {
    
    @StateObject
    private var rootHolder = RootHolder()
    
    var body: some Scene {
        WindowGroup {
            RootView(rootHolder.rootComponent)
                .onAppear { LifecycleRegistryExtKt.resume(self.rootHolder.lifecycle) }
                .onDisappear { LifecycleRegistryExtKt.stop(self.rootHolder.lifecycle) }
        }
    }
}

private class RootHolder : ObservableObject {
    let lifecycle: LifecycleRegistry
    let rootComponent: RootComponent
    
    init() {
        let configuration = Configuration(
            platform: Platform(),
            buildType: BuildType.debug,
            backend: Backend.development
        )
        let core = Core(configuration: configuration)
        
        lifecycle = LifecycleRegistryKt.LifecycleRegistry()
        rootComponent = core.createRootComponent(
            componentContext: DefaultComponentContext(lifecycle: lifecycle)
        )
        lifecycle.onCreate()
    }
    
    deinit {
        lifecycle.onDestroy()
    }
}

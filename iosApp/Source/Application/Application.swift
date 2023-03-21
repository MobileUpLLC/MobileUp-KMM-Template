import SwiftUI

@main
struct Application: App {
    @StateObject
    private var rootHolder = RootHolder()
        
    var body: some Scene {
        WindowGroup {
            RootView(component: rootHolder.rootComponent)
                .onAppear { LifecycleRegistryExtKt.resume(self.rootHolder.lifecycle) }
                .onDisappear { LifecycleRegistryExtKt.stop(self.rootHolder.lifecycle) }
        }
    }
}

private class RootHolder: ObservableObject {
    let lifecycle: LifecycleRegistry
    let rootComponent: RootComponent
    
    init() {
        let buildType: BuildType
        let backend: Backend
        
        switch EnvironmentService.shared.currentEnvironment {
        case .debug:
            buildType = .debug
            backend = .development
        case .release:
            buildType = .release_
            backend = .production
        }
        
        let configuration = Configuration(
            platform: Platform(),
            buildType: buildType,
            backend: backend
        )
        
        AppearanceService.setup()
        
        let core = Core(configuration: configuration)
        lifecycle = LifecycleRegistryKt.LifecycleRegistry()
        
        rootComponent = core.createRootComponent(
            componentContext: DefaultComponentContext(
                lifecycle: lifecycle,
                stateKeeper: nil,
                instanceKeeper: nil,
                backHandler: BackDispatcherService.shared.backDispatcher
            )
        )
        
        lifecycle.onCreate()
    }
    
    deinit {
        lifecycle.onDestroy()
    }
}

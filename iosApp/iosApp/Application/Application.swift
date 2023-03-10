import SwiftUI
import shared

var globalBackDispatcher: BackDispatcher? = nil // TODO: можно сделать без глобальной переменной?

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

private class RootHolder : ObservableObject {
    let lifecycle: LifecycleRegistry
    let backDispatcher: BackDispatcher
    let rootComponent: RootComponent
    
    init() {
        let configuration = Configuration( // TODO: задавать buildType и backend в зависимости от типа сборки
            platform: Platform(),
            buildType: BuildType.debug,
            backend: Backend.development
        )
        let core = Core(configuration: configuration)
        
        lifecycle = LifecycleRegistryKt.LifecycleRegistry()
        backDispatcher = BackDispatcherKt.BackDispatcher()
        globalBackDispatcher = backDispatcher
        rootComponent = core.createRootComponent(
            componentContext: DefaultComponentContext(
                lifecycle: lifecycle,
                stateKeeper: nil,
                instanceKeeper: nil,
                backHandler: backDispatcher
            )
        )
        lifecycle.onCreate()
    }
    
    deinit {
        lifecycle.onDestroy()
    }
}

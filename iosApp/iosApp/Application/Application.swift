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
    
    // TODO: нужно вызывать этот метод при нажатии кнопки "Назад"
    func dispatchBackPressed() {
        rootHolder.backDispatcher.back()
    }
}

private class RootHolder : ObservableObject {
    let lifecycle: LifecycleRegistry
    let backDispatcher: BackDispatcher
    let rootComponent: RootComponent
    
    init() {
        let configuration = Configuration(
            platform: Platform(),
            buildType: BuildType.debug,
            backend: Backend.development
        )
        let core = Core(configuration: configuration)
        
        lifecycle = LifecycleRegistryKt.LifecycleRegistry()
        backDispatcher = BackDispatcherKt.BackDispatcher()
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

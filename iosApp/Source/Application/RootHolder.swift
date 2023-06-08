//
//  RootHolder.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 27.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

final class RootHolder: ObservableObject {
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
        
        let defaultComponentContext = DefaultComponentContext(
            lifecycle: lifecycle,
            stateKeeper: nil,
            instanceKeeper: nil,
            backHandler: BackDispatcherService.shared.backDispatcher
        )
        
        rootComponent = core.createRootComponent(componentContext: defaultComponentContext)
        
        lifecycle.onCreate()
    }
    
    func onViewAppear() {
        LifecycleRegistryExtKt.resume(lifecycle)
    }
    
    func onViewDisappear() {
        LifecycleRegistryExtKt.stop(lifecycle)
    }
    
    deinit {
        lifecycle.onDestroy()
    }
}

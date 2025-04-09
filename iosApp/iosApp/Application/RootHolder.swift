//
//  RootHolder.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 27.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

final class RootHolder: ObservableObject {
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
        
        let defaultComponentContext = DefaultComponentContext(
            lifecycle: ApplicationLifecycle(),
            stateKeeper: nil,
            instanceKeeper: nil,
            backHandler: BackDispatcherService.shared.backDispatcher
        )
        
        rootComponent = core.createRootComponent(componentContext: defaultComponentContext)
    }
}

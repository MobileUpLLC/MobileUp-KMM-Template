//
//  RootHolder.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 27.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

/**
 * Класс `RootHolder` используется для хранения и инициализации корневого компонента приложения. Он управляет настройками и контекстом
 * компонента, который используется в приложении. Этот класс инициализирует все зависимости, включая конфигурацию и жизненный цикл
 * компонента, и предоставляет доступ к корневому компоненту.
 *
 * Основные элементы:
 * - Инициализация конфигурации и жизненного цикла приложения в зависимости от окружения (debug/release).
 * - Создание экземпляра `RootComponent` на основе конфигурации.
 */
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
            buildType = .theRelease
            backend = .production
        }
        
        let configuration = Configuration(
            platform: Platform(),
            buildType: buildType,
            backend: backend
        )
        
        let core = Core(configuration: configuration)
        
        /// Создание контекста компонента с жизненным циклом, обработчиком состояния и обработчиком возврата.
        let defaultComponentContext = DefaultComponentContext(
            lifecycle: ApplicationLifecycle(),
            stateKeeper: nil,
            instanceKeeper: nil,
            backHandler: BackDispatcherService.shared.backDispatcher
        )
        
        /// Инициализация корневого компонента с использованием созданного контекста.
        rootComponent = core.createRootComponent(componentContext: defaultComponentContext)
    }
}

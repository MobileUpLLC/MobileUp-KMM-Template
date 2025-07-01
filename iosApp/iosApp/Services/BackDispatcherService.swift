//
//  BackDispatcherService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 20.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

/**
 * `BackDispatcherService` — это сервис, который предоставляет доступ к глобальной инстанции `BackDispatcher`.
 * Этот класс является синглтоном, обеспечивающим централизованный доступ к механизмам обработки действий "назад".
 *
 * Важным аспектом является его взаимодействие с Kotlin Multiplatform (KMM), так как он инициализирует объект
 * `BackDispatcher` из KMM, что позволяет управлять действиями навигации "назад" как в iOS, так и в Android.
 *
 * Свойства:
 * - `backDispatcher`: Экземпляр `BackDispatcher`, предоставляющий функциональность для обработки навигации "назад".
 *
 * Методы:
 * - `init()`: Инициализирует сервис, создавая экземпляр `BackDispatcher` из KMM.
 *
 * Примечания:
 * - Класс использует синглтон для того, чтобы обеспечить единую точку доступа к `BackDispatcher` во всей системе.
 */
@MainActor
final class BackDispatcherService {
    /// Глобальная синглтон-инстанция для доступа к сервису.
    static let shared = BackDispatcherService()
    
    /// Экземпляр `BackDispatcher` из Kotlin Multiplatform (KMM).
    let backDispatcher: BackDispatcher
    
    private init() {
        backDispatcher = BackDispatcherKt.BackDispatcher()
    }
}

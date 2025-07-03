//
//  PagedStateFlow.swift
//  iosApp
//
//  Created by Denis Dmitriev on 17.06.2025.
//

import SwiftUI

/// Property wrapper для интеграции `PagedState` из Kotlin Multiplatform с SwiftUI.
///
/// Наблюдает за `SkieSwiftStateFlow<PagedState<T>>` и предоставляет данные, ошибку и статус загрузки
/// для использования в SwiftUI-интерфейсе. Обновления происходят асинхронно на главном потоке.
///
/// Используется для обработки пагнированных данных, таких как списки, с поддержкой состояний загрузки
/// первой, следующей или предыдущей страницы.
///
/// - Parameters:
///   - T: Тип данных в `PagedState`, должен соответствовать `AnyObject` и `Sendable`.
@propertyWrapper
final class PagedStateFlow<T: AnyObject & Sendable>: ObservableObject {
    /// Тип статуса загрузки, соответствующий `Replica_corePagedLoadingStatus`.
    typealias LoadingStatus = Replica_corePagedLoadingStatus
    
    /// Текущее значение данных, полученное из `PagedState`.
    @MainActor @Published var wrappedValue: T?
    
    /// Описание ошибки, если она произошла во время загрузки.
    @MainActor @Published var error: shared.StringDesc?
    
    /// Текущий статус загрузки (например, `none`, `loadingFirstPage`, `loadingNextPage`, `loadingPreviousPage`).
    @MainActor @Published var loadingStatus: LoadingStatus
    
    /// Текущее значение данных, эквивалентное `wrappedValue`.
    @MainActor var data: T? {
        wrappedValue
    }
    
    /// Указывает, выполняется ли в данный момент загрузка первой страницы.
    @MainActor var isLoading: Bool {
        loadingStatus == .loadingFirstPage
    }
    
    /// Задача для управления подпиской на поток.
    private var task: Task<Void, Never>?
    
    /// Инициализирует property wrapper с переданным `SkieSwiftStateFlow<PagedState<T>>`.
    ///
    /// - Parameter stateFlow: Поток `PagedState`, за которым ведётся наблюдение.
    /// - Note: Подписка на поток выполняется асинхронно, а обновления UI происходят на главном потоке.
    @MainActor
    init(_ stateFlow: SkieSwiftStateFlow<PagedState<T>>) {
        self.wrappedValue = stateFlow.value.data
        self.error = stateFlow.value.error
        self.loadingStatus = stateFlow.value.loadingStatus
        
        self.task = Task {
            for await item in stateFlow {
                await MainActor.run {
                    self.wrappedValue = item.data
                    self.error = item.error
                    self.loadingStatus = item.loadingStatus
                }
            }
        }
    }
    
    /// Освобождает ресурсы, отменяя подписку на поток.
    deinit {
        task?.cancel()
    }
}

/// Расширение для поддержки инициализации `StateObject` с `PagedStateFlow`.
extension StateObject {
    /// Инициализирует `StateObject` с переданным `SkieSwiftStateFlow<PagedState<T>>`.
    ///
    /// - Parameter stateFlow: Поток `PagedState`, который будет наблюдаться.
    init<T: AnyObject & Sendable>(_ stateFlow: SkieSwiftStateFlow<PagedState<T>>) where ObjectType == PagedStateFlow<T> {
        self.init(wrappedValue: PagedStateFlow(stateFlow))
    }
}

/// Расширение для поддержки инициализации `ObservedObject` с `PagedStateFlow`.
extension ObservedObject {
    /// Инициализирует `ObservedObject` с переданным `SkieSwiftStateFlow<PagedState<T>>`.
    ///
    /// - Parameter stateFlow: Поток `PagedState`, который будет наблюдаться.
    init<T: AnyObject & Sendable>(_ stateFlow: SkieSwiftStateFlow<PagedState<T>>) where ObjectType == PagedStateFlow<T> {
        self.init(wrappedValue: PagedStateFlow(stateFlow))
    }
}

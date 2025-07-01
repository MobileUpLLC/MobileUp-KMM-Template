//
//  LoadableStateFlow.swift
//  iosApp
//
//  Created by Denis Dmitriev on 22.05.2025.
//

import SwiftUI

/// Property wrapper для работы с LoadableState в SwiftUI, интегрированный с KotlinStateFlow.
/// Наблюдает за SkieSwiftStateFlow<LoadableState<T>> и предоставляет данные, ошибку и состояние загрузки.
///
/// - Parameters:
///   - T: Тип данных в LoadableState, должен быть AnyObject и Sendable.
@propertyWrapper
final class LoadableStateFlow<T: AnyObject & Sendable>: ObservableObject {
    /// Текущее значение LoadableState, включая data, error и loading.
    @MainActor @Published var wrappedValue: T?
    
    @MainActor var data: T? {
        wrappedValue
    }
    @MainActor @Published var error: shared.StringDesc?
    @MainActor @Published var loading: Bool
    
    /// Задача для управления подпиской на поток.
    private var task: Task<Void, Never>?
    
    /// Инициализирует property wrapper с переданным SkieSwiftStateFlow<LoadableState<T>>.
    ///
    /// - Parameter stateFlow: Поток, за которым ведётся наблюдение.
    @MainActor
    init(_ stateFlow: SkieSwiftStateFlow<LoadableState<T>>) {
        self.wrappedValue = stateFlow.value.data
        self.error = stateFlow.value.error
        self.loading = stateFlow.value.loading
        
        self.task = Task {
            for await item in stateFlow {
                await MainActor.run {
                    wrappedValue = item.data
                    error = item.error
                    loading = item.loading
                }
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
}

/// Расширение для поддержки инициализации StateObject с LoadableStateFlow.
extension StateObject {
    init<T: AnyObject & Sendable>(_ stateFlow: SkieSwiftStateFlow<LoadableState<T>>) where ObjectType == LoadableStateFlow<T> {
        self.init(wrappedValue: LoadableStateFlow(stateFlow))
    }
}

/// Расширение для поддержки ObservedObject.
extension ObservedObject {
    init<T: AnyObject & Sendable>(_ stateFlow: SkieSwiftStateFlow<LoadableState<T>>) where ObjectType == LoadableStateFlow<T> {
        self.init(wrappedValue: LoadableStateFlow(stateFlow))
    }
}

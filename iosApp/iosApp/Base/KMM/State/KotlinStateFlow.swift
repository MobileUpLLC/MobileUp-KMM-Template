//
//  KotlinStateFlow.swift
//  iosApp
//
//  Created by Denis Dmitriev on 14.04.2025.
//

import SwiftUI

/// Обёртка над `SkieSwiftStateFlow`, предназначенная для интеграции с SwiftUI.
///
/// `KotlinStateFlow` наблюдает за Kotlin Multiplatform `StateFlow` с типом значений
/// и предоставляет его данные в SwiftUI через свойство `@Published`.
///
/// Используется, когда необходимо получать обновления из KMM-кода и автоматически обновлять SwiftUI-интерфейс.
///
/// - Примечание: Подписка осуществляется асинхронно, обновления происходят на главном потоке.
///
/// - Параметры:
///   - T: Тип значения, за которым ведётся наблюдение. Должен соответствовать `Sendable`.
@propertyWrapper
final class KotlinStateFlow<T: Sendable>: ObservableObject {
    /// Текущее значение, полученное из `stateFlow`.
    @MainActor @Published var wrappedValue: T
    /// Задача для управления подпиской на поток.
    private var task: Task<Void, Never>?

    /// Инициализирует обёртку с переданным потоком `SkieSwiftStateFlow`.
    ///
    /// - Parameter value: Экземпляр `SkieSwiftStateFlow`, за которым будет вестись наблюдение.
    @MainActor init(_ value: SkieSwiftStateFlow<T>) {
        wrappedValue = value.value
        
        self.task = Task {
            for await item in value {
                Task { @MainActor in
                    wrappedValue = item
                }
            }
        }
    }

    deinit {
        task?.cancel()
    }
}

extension ObservedObject {
    /// Инициализатор `ObservedObject`, оборачивающий `SkieSwiftStateFlow`.
    init<F: Sendable>(_ stateFlow: SkieSwiftStateFlow<F>) where ObjectType == KotlinStateFlow<F> {
        self.init(wrappedValue: KotlinStateFlow(stateFlow))
    }
}

extension StateObject {
    /// Инициализатор `StateObject`, оборачивающий `SkieSwiftStateFlow`.
    init<F: Sendable>(_ stateFlow: SkieSwiftStateFlow<F>) where ObjectType == KotlinStateFlow<F> {
        self.init(wrappedValue: KotlinStateFlow(stateFlow))
    }
}

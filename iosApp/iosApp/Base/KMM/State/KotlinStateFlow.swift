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
///   - T: Тип значения, за которым ведётся наблюдение. Должен соответствовать `Any`.
@propertyWrapper
final class KotlinStateFlow<T: Any>: ObservableObject {
    /// Внутренний поток Kotlin, эмитящий значения типа `T`.
    private let stateFlow: SkieSwiftStateFlow<T>
    /// Текущее значение, полученное из `stateFlow`.
    @Published var wrappedValue: T

    private var publisher: Task<(), Never>?

    /// Инициализирует обёртку с переданным потоком `SkieSwiftStateFlow`.
    ///
    /// - Parameter value: Экземпляр `SkieSwiftStateFlow`, за которым будет вестись наблюдение.
    init(_ value: SkieSwiftStateFlow<T>) {
        self.stateFlow = value
        self.wrappedValue = value.value

        self.publisher = Task { @MainActor [weak self] in
            if let stateFlow = self?.stateFlow {
                for await item in stateFlow {
                    self?.wrappedValue = item
                }
            }
        }
    }

    deinit {
        if let publisher {
            publisher.cancel()
        }
    }
}

extension ObservedObject {
    /// Инициализатор `ObservedObject`, оборачивающий `SkieSwiftStateFlow`.
    init<F>(_ stateFlow: SkieSwiftStateFlow<F>) where ObjectType == KotlinStateFlow<F> {
        self.init(wrappedValue: KotlinStateFlow(stateFlow))
    }
}

extension StateObject {
    /// Инициализатор `StateObject`, оборачивающий `SkieSwiftStateFlow`.
    init<F>(_ stateFlow: SkieSwiftStateFlow<F>) where ObjectType == KotlinStateFlow<F> {
        self.init(wrappedValue: KotlinStateFlow(stateFlow))
    }
}

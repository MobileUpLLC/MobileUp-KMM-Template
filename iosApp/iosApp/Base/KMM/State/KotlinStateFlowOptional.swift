//
//  KotlinStateFlowOptional.swift
//  iosApp
//
//  Created by Denis Dmitriev on 14.04.2025.
//

import SwiftUI

/// Обёртка над `SkieSwiftOptionalStateFlow`, предназначенная для интеграции с SwiftUI.
///
/// `KotlinOptionalStateFlow` наблюдает за Kotlin Multiplatform `StateFlow`, содержащим **опциональные** значения,
/// и предоставляет их в SwiftUI через свойство `@Published`.
///
/// Используется, когда необходимо получать обновления из KMM-кода, где значения могут быть `nil`,
/// и автоматически обновлять интерфейс SwiftUI.
///
/// - Примечание: Подписка осуществляется асинхронно, обновления происходят на главном потоке.
///
/// - Параметры:
///   - T: Тип значения, за которым ведётся наблюдение. Должен соответствовать `Any`.
@propertyWrapper
final class KotlinOptionalStateFlow<T: Any>: ObservableObject {
    /// Внутренний поток Kotlin, эмитящий значения типа `T?`.
    private let stateFlow: SkieSwiftOptionalStateFlow<T>
    /// Текущее значение, полученное из `stateFlow`.
    @Published var wrappedValue: T?

    private var publisher: Task<(), Never>?

    /// Инициализирует обёртку с переданным потоком `SkieSwiftOptionalStateFlow`.
    ///
    /// - Parameter value: Экземпляр `SkieSwiftOptionalStateFlow`, за которым будет вестись наблюдение.
    init(_ value: SkieSwiftOptionalStateFlow<T>) {
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
    /// Инициализатор `ObservedObject`, оборачивающий `SkieSwiftOptionalStateFlow`.
    init<F>(_ stateFlow: SkieSwiftOptionalStateFlow<F>) where ObjectType == KotlinOptionalStateFlow<F> {
        self.init(wrappedValue: KotlinOptionalStateFlow(stateFlow))
    }
}

extension StateObject {
    /// Инициализатор `StateObject`, оборачивающий `SkieSwiftOptionalStateFlow`.
    init<F>(_ stateFlow: SkieSwiftOptionalStateFlow<F>) where ObjectType == KotlinOptionalStateFlow<F> {
        self.init(wrappedValue: KotlinOptionalStateFlow(stateFlow))
    }
}

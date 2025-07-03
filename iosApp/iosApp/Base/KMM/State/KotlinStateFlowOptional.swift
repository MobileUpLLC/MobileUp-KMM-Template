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
///   - T: Тип значения, за которым ведётся наблюдение. Должен соответствовать `Sendable`.
@MainActor
@propertyWrapper
final class KotlinOptionalStateFlow<T: Sendable>: ObservableObject {
    /// Текущее значение, полученное из `stateFlow`.
    @MainActor @Published var wrappedValue: T?
    /// Задача для управления подпиской на поток.
    private var task: Task<Void, Never>?

    /// Инициализирует обёртку с переданным потоком `SkieSwiftOptionalStateFlow`.
    ///
    /// - Parameter value: Экземпляр `SkieSwiftOptionalStateFlow`, за которым будет вестись наблюдение.
    @MainActor init(_ value: SkieSwiftOptionalStateFlow<T>) {
        self.wrappedValue = value.value

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
    /// Инициализатор `ObservedObject`, оборачивающий `SkieSwiftOptionalStateFlow`.
    init<F: Sendable>(_ stateFlow: SkieSwiftOptionalStateFlow<F>) where ObjectType == KotlinOptionalStateFlow<F> {
        self.init(wrappedValue: KotlinOptionalStateFlow(stateFlow))
    }
}

extension StateObject {
    /// Инициализатор `StateObject`, оборачивающий `SkieSwiftOptionalStateFlow`.
    init<F: Sendable>(_ stateFlow: SkieSwiftOptionalStateFlow<F>) where ObjectType == KotlinOptionalStateFlow<F> {
        self.init(wrappedValue: KotlinOptionalStateFlow(stateFlow))
    }
}

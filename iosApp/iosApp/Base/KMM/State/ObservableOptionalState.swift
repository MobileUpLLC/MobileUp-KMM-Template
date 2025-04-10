import SwiftUI

/// Обёртка над `SkieSwiftOptionalStateFlow`, предназначенная для использования в SwiftUI.
///
/// `ObservableOptionalState` наблюдает за Kotlin Multiplatform `StateFlow`, который может
/// эмитить опциональные значения, и предоставляет их в SwiftUI через свойство `@Published`.
///
/// Используется для привязки к значению, которое приходит из общего (KMM) кода,
/// чтобы автоматически обновлять SwiftUI-интерфейс при изменении этого значения.
///
/// - Примечание: Наблюдение за значениями происходит асинхронно и обновления выполняются на главном потоке.
///
/// - Параметры:
///   - T: Тип значения, за которым ведётся наблюдение. Должен соответствовать `Any`.
final class ObservableOptionalState<T: Any>: ObservableObject {
    /// Последнее значение, полученное из `flow`
    @Published var value: T?
    /// Внутренний поток Kotlin, который эмитит опциональные значения.
    private let flow: SkieSwiftOptionalStateFlow<T>
    
    /// Инициализирует обёртку с переданным потоком `SkieSwiftOptionalStateFlow`.
    ///
    /// - Parameter flow: Экземпляр `SkieSwiftOptionalStateFlow`, за которым будет вестись наблюдение.
    init(_ flow: SkieSwiftOptionalStateFlow<T>) {
        self.flow = flow
        value = flow.value
        
        Task { await sink() }
    }
    
    /// Асинхронно подписывается на поток и обновляет `value` при получении новых значений.
    @MainActor
    func sink() async {
        for await value in flow {
            self.value = value
        }
    }
}

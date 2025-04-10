import SwiftUI

/// Обёртка над `SkieSwiftStateFlow`, предназначенная для интеграции с SwiftUI.
///
/// `ObservableState` наблюдает за Kotlin Multiplatform `StateFlow` с не опциональным типом значений
/// и предоставляет его данные в SwiftUI через свойство `@Published`.
///
/// Используется, когда необходимо получать обновления из KMM-кода и автоматически обновлять SwiftUI-интерфейс.
///
/// - Примечание: Подписка осуществляется асинхронно, обновления происходят на главном потоке.
///
/// - Параметры:
///   - T: Тип значения, за которым ведётся наблюдение. Должен соответствовать `Any`.
final class ObservableState<T: Any>: ObservableObject {
    /// Текущее значение, полученное из `flow`
    @Published var value: T
    /// Внутренний поток Kotlin, эмитящий значения типа `T`.
    private let flow: SkieSwiftStateFlow<T>
    
    /// Инициализирует обёртку с переданным потоком `SkieSwiftStateFlow`.
    ///
    /// - Parameter flow: Экземпляр `SkieSwiftStateFlow`, за которым будет вестись наблюдение.
    init(_ flow: SkieSwiftStateFlow<T>) {
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

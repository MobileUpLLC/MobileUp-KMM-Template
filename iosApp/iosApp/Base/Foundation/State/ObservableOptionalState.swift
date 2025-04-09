/**
 * Used to observe SkieSwiftOptionalStateFlow from SwiftUI
 */
import SwiftUI

final class ObservableOptionalState<T: Any>: ObservableObject {
    @Published var value: T?
    
    private let flow: SkieSwiftOptionalStateFlow<T>
    
    init(_ flow: SkieSwiftOptionalStateFlow<T>) {
        self.flow = flow
        value = flow.value

        Task { await sink() }
    }
    
    @MainActor
    func sink() async {
        for await value in flow {
            self.value = value
        }
    }
}

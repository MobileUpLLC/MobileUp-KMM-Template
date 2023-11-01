import Foundation
import Combine
/**
 * Used to observe Flow from SwiftUI.
 * NOTE: It is unsafe. Types and nullability are not checked in compile time.
 */

final class UnsafeObservableState<T: AnyObject>: ObservableObject {
    @Published var value: T?

    private var cancelable: Cancelable?

    init(_ state: Kotlinx_coroutines_coreStateFlow) {
        value = state.value as? T
        
        cancelable = FlowWrapper<T>(flow: state).collect { [weak self] value in
            self?.value = value
        }
    }
    
    func reemitValue() {
        value = value
    }
   
    deinit {
        self.cancelable?.cancel()
    }
}

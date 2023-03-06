import shared

/**
 * Used to observe Flow from SwiftUI.
 * NOTE: It is unsafe. Types and nullability are not checked in compile time.
 */
public final class UnsafeObservableState<T: AnyObject>: ObservableObject {
    @Published var value: T?

    private var cancelable: Cancelable? = nil

    init(_ state: Kotlinx_coroutines_coreStateFlow) {
        self.value = state.value as? T
        
        cancelable = FlowWrapper<T>(flow: state).collect { value in
            self.value = value
        }
    }
    
    func reemitValue() {
        value = value
    }
   
    deinit {
        self.cancelable?.cancel()
    }
}
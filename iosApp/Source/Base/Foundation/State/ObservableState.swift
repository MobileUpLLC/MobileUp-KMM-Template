/**
 * Used to observe CStateFlow from SwiftUI
 */
final class ObservableState<T: AnyObject>: ObservableObject {
    @Published var value: T
    
    private var cancelable: Cancelable?
    
    init(_ state: StateFlow<T>) {
        value = state.value

        cancelable = FlowWrapper<T>(flow: state).collect(
            consumer: { [weak self] value in
                if let value {
                    self?.value = value
                }
            }
        )
    }
    
    func recreate(_ state: StateFlow<T>) {
        cancelable?.cancel()
        
        cancelable = FlowWrapper<T>(flow: state).collect(
            consumer: { [weak self] value in
                if let value {
                    self?.value = value
                }
            }
        )
    }
    
    deinit {
        self.cancelable?.cancel()
    }
}

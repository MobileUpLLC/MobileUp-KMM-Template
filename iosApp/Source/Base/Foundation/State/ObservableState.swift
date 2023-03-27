/**
 * Used to observe CStateFlow from SwiftUI
 */
public class ObservableState<T: AnyObject>: ObservableObject {
    @Published var value: T
    
    private var cancelable: Cancelable?
    
    init(_ state: CStateFlow<T>) {
        self.value = state.value

        cancelable = FlowWrapper<T>(flow: state).collect(
            consumer: { value in
                if let value {
                    self.value = value
                }
            }
        )
    }
    
    deinit {
        self.cancelable?.cancel()
    }
}

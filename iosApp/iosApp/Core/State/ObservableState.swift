import shared

/**
 * Used to observe CStateFlow from SwiftUI
 */
public class ObservableState<T: AnyObject>: ObservableObject {
    
    @Published
    var value: T
    
    private var cancelable: Cancelable? = nil
    
    init(_ state: CStateFlow<T>) {
        self.value = state.value

        cancelable = FlowWrapper(flow: state).collect(consumer: { value in
             self.value = value!
         })
    }
    
    deinit {
        self.cancelable?.cancel()
    }
}

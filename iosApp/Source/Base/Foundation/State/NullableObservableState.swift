/**
 * Used to observe CNullableStateFlow from SwiftUI
 */
public class NullableObservableState<T: AnyObject>: ObservableObject {
    @Published
    var value: T?
    
    private var cancelable: Cancelable?
    
    init(_ state: CNullableStateFlow<T>) {
        self.value = state.value

        cancelable = FlowWrapper(flow: state).collect(consumer: { value in
             self.value = value
         })
    }
    
    deinit {
        self.cancelable?.cancel()
    }
}

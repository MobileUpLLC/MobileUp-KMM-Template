import Foundation
import Combine

final class ObservableStateFlow<T: AnyObject>: ObservableObject {
    @Published
    private(set) var value: T
    
    private let flow: SkieSwiftStateFlow<T>
    
    init(flow: SkieSwiftStateFlow<T>) {
        self.flow = flow
        value = flow.value
    }

    @MainActor
    func activate() async {
        for await value in flow {
            self.value = value
        }
    }
}

/**
 * Used to observe CStateFlow from SwiftUI
 */
final class ObservableState<T: AnyObject>: ObservableObject {
    @Published var value: T
    
    private var cancelable: Cancelable?
    
    init(_ state: CStateFlow<T>) {
        value = state.value

        cancelable = FlowWrapper<T>(flow: state).collect(
            consumer: { [weak self] value in
                if let value {
                    self?.value = value
                }
            }
        )
    }
    
    func recreate(_ state: CStateFlow<T>) {
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

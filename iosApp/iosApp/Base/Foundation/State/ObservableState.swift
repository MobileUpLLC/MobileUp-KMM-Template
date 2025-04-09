/**
 * Used to observe SkieSwiftStateFlow from SwiftUI
 */

import SwiftUI

final class ObservableState<T: Any>: ObservableObject {
    @Published var value: T
    
    private let flow: SkieSwiftStateFlow<T>
    
    init(_ flow: SkieSwiftStateFlow<T>) {
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
    
    /*
    func recreate(_ state: CStateFlow<T>) {
        cancelable?.cancel()
        
        cancelable = FlowWrapper<T>(flow: state)
            .collect(consumer: { [weak self] value in
                if let value {
                    self?.value = value
                }
            })
    }
     */
}

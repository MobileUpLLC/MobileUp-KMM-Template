//
//  CFlowWrapper.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.05.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

final class CFlowWrapper<T: AnyObject> {
    private var cancelable: Cancelable?
    private var onCollect: Closure.Generic<T>?
    
    init(_ state: CFlow<T>) {
        cancelable = FlowWrapper<T>(flow: state).collect(
            consumer: { [weak self] value in
                if let value {
                    self?.onCollect?(value)
                }
            }
        )
    }
    
    func set(onCollect: Closure.Generic<T>?) {
        self.onCollect = onCollect
    }
    
    deinit {
        self.cancelable?.cancel()
    }
}

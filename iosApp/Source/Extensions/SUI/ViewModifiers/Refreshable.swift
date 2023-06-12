//
//  Refreshable.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 20.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

extension View {
    func refreshable<T>(
        loadingState: ObservableState<LoadableState<T>>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) -> some View {
        return self.refreshable {
            await refresh(loadingState: loadingState, onRefresh: onRefresh, didRefresh: didRefresh)
        }
    }
    
    private func refresh<T>(
        loadingState: ObservableState<LoadableState<T>>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) async {
        onRefresh()
        
        while loadingState.value.loading == false {
            await Task.yield()
        }
        
        while loadingState.value.loading {
            await Task.yield()
        }
        
        didRefresh()
    }
}

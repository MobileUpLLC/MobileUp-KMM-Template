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
        loadingState: KotlinStateFlow<LoadableState<T>>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) -> some View {
        return self.refreshable {
            await refresh(loadingState: loadingState, onRefresh: onRefresh, didRefresh: didRefresh)
        }
    }
    
    func refreshable<T>(
        loadingState: LoadableStateFlow<T>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) -> some View {
        return self.refreshable {
            await refresh(loadingState: loadingState, onRefresh: onRefresh, didRefresh: didRefresh)
        }
    }
    
    func refreshable<T: AnyObject & Sendable>(
        pagedState: PagedStateFlow<T>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) -> some View {
        return self.refreshable {
            await refresh(pagedState: pagedState, onRefresh: onRefresh, didRefresh: didRefresh)
        }
    }
    
    private func refresh<T>(
        loadingState: KotlinStateFlow<LoadableState<T>>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) async {
        onRefresh()
        
        while loadingState.wrappedValue.loading == false {
            await Task.yield()
        }
        
        while loadingState.wrappedValue.loading {
            await Task.yield()
        }
        
        didRefresh()
    }
    
    private func refresh<T>(
        loadingState: LoadableStateFlow<T>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) async {
        onRefresh()
        
        while loadingState.loading == false {
            await Task.yield()
        }
        
        while loadingState.loading {
            await Task.yield()
        }
        
        didRefresh()
    }
    
    private func refresh<T: AnyObject & Sendable>(
        pagedState: PagedStateFlow<T>,
        onRefresh: @escaping Closure.Void,
        didRefresh: @escaping Closure.Void
    ) async {
        onRefresh()
        
        while pagedState.isLoading == false {
            await Task.yield()
        }
        
        while pagedState.isLoading {
            await Task.yield()
        }
        
        didRefresh()
    }
}

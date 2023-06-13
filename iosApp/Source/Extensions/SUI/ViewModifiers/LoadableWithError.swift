//
//  LoadableWithError.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 18.05.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI

extension View {
    func loadableWithError<T: AnyObject>(
        loadableState: ObservableState<LoadableState<T>>,
        emptyStateDescription: String? = nil,
        maxLoadingHeight: CGFloat = .infinity,
        verticalInsets: CGFloat = .zero,
        isWithBackSwipe: Bool = false,
        onRefresh: Closure.Void?,
        onRetryClick: Closure.Void?
    ) -> some View {
        let refreshableLoadableModifier = RefreshableLoadableWithErrorModifier(
            loadableState: loadableState,
            emptyStateDescription: emptyStateDescription,
            maxLoadingHeight: maxLoadingHeight,
            verticalInsets: verticalInsets,
            isWithBackSwipe: isWithBackSwipe,
            onRefresh: onRefresh,
            onRetryClick: onRetryClick
        )
        
        return modifier(refreshableLoadableModifier)
    }
}

private struct RefreshableLoadableWithErrorModifier<T: AnyObject>: ViewModifier {
    @ObservedObject var loadableState: ObservableState<LoadableState<T>>
    let emptyStateDescription: String?
    let maxLoadingHeight: CGFloat
    let verticalInsets: CGFloat
    let isWithBackSwipe: Bool
    let onRefresh: Closure.Void?
    let onRetryClick: Closure.Void?
    
    @State private var isRefreshing = false
    
    func body(content: Content) -> some View {
        ZStack {
            if let error = loadableState.value.error {
                FullScreenErrorView(
                    error: error.localized(),
                    isWithBackSwipe: isWithBackSwipe,
                    onRetryClick: onRetryClick
                )
            } else if
                let emptyStateDescription,
                loadableState.value.loading == false,
                let data = loadableState.value.data as? NSArray,
                data.count == .zero
            {
                FullScreenEmptyView(
                    emptyStateDescription: emptyStateDescription,
                    verticalInsets: verticalInsets,
                    isWithBackSwipe: isWithBackSwipe,
                    isRefreshable: onRefresh != nil
                )
            } else {
                content
            }
            
            if loadableState.value.loading && isRefreshing == false {
                FullScreenLoadingView(isWithBackSwipe: isWithBackSwipe)
                    .frame(maxHeight: maxLoadingHeight)
                    .zIndex(1)
            }
        }
        .animation(.easeIn, value: loadableState.value.loading)
        .animation(.easeIn, value: loadableState.value.error != nil)
        .transition(.opacity)
        .if(onRefresh != nil) { view in
            view
                .refreshable(
                    loadingState: loadableState,
                    onRefresh: {
                        isRefreshing = true
                        
                        onRefresh?()
                    },
                    didRefresh: { isRefreshing = false }
                )
        }
    }
}

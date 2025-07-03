//
//  LoadableStateWithError.swift
//  iosApp
//
//  Created by Denis Dmitriev on 22.05.2025.
//

import SwiftUI

extension View {
    func loadableSate<T: AnyObject>(
        loadableState: LoadableStateFlow<T>,
        emptyStateDescription: String? = nil,
        maxLoadingHeight: CGFloat = .infinity,
        verticalInsets: CGFloat = .zero,
        isWithBackSwipe: Bool = false,
        onRefresh: Closure.Void?,
        onRetryClick: Closure.Void?
    ) -> some View {
        let refreshableLoadableModifier = LoadableStateModifier(
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

private struct LoadableStateModifier<T: AnyObject & Sendable>: ViewModifier {
    @ObservedObject var loadableState: LoadableStateFlow<T>
    let emptyStateDescription: String?
    let maxLoadingHeight: CGFloat
    let verticalInsets: CGFloat
    let isWithBackSwipe: Bool
    let onRefresh: Closure.Void?
    let onRetryClick: Closure.Void?
    
    @State private var isRefreshing = false
    
    func body(content: Content) -> some View {
        ZStack {
            if let error = loadableState.error {
                FullScreenErrorView(
                    error: error.localized(),
                    isWithBackSwipe: isWithBackSwipe,
                    onRetryClick: onRetryClick
                )
            } else if
                let emptyStateDescription,
                loadableState.loading == false,
                let data = loadableState.data as? NSArray,
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
            
            if loadableState.loading && isRefreshing == false {
                FullScreenLoadingView(isWithBackSwipe: isWithBackSwipe)
                    .frame(maxHeight: maxLoadingHeight)
                    .zIndex(1)
            }
        }
        .animation(.easeIn, value: loadableState.loading)
        .animation(.easeIn, value: loadableState.error != nil)
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

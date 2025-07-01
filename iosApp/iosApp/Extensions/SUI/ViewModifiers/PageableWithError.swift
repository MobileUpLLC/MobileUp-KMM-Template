//
//  PageableWithError.swift
//  iosApp
//
//  Created by Denis Dmitriev on 17.06.2025.
//

import SwiftUI

extension View {
    func pageableState<T: AnyObject & Sendable>(
        pagedState: PagedStateFlow<T>,
        onRefresh: (() -> Void)?,
        onRetryClick: (() -> Void)?
    ) -> some View {
        return modifier(
            PageableWithError(
                pagedState: pagedState,
                onRefresh: onRefresh,
                onRetryClick: onRetryClick
            )
        )
    }
}

struct PageableWithError<T: AnyObject & Sendable>: ViewModifier {
    @ObservedObject var pagedState: PagedStateFlow<T>
    
    let onRefresh: (() -> Void)?
    let onRetryClick: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            if let error = pagedState.error {
                FullScreenErrorView(
                    error: error.localized(),
                    isWithBackSwipe: false,
                    onRetryClick: onRetryClick
                )
            }
            
            switch pagedState.loadingStatus {
            case .loadingFirstPage:
                FullScreenLoadingView(isWithBackSwipe: false)
                    .frame(maxHeight: .infinity)
                    .zIndex(1)
            case .loadingPreviousPage, .loadingNextPage, .none:
                let isLoadingPreviousPage = pagedState.loadingStatus == .loadingPreviousPage
                let edge: VerticalEdge = isLoadingPreviousPage ? .top : .bottom
                let isShowContent = pagedState.loadingStatus == .none
                content
                    .safeAreaInset(edge: edge) {
                        if isShowContent == false {
                            LoadingView()
                                .padding(.vertical)
                        }
                    }
            }
        }
        .animation(.easeIn, value: pagedState.isLoading)
        .animation(.easeIn, value: pagedState.error != nil)
        .transition(.opacity)
        .if(onRefresh != nil) { view in
            view
                .refreshable(
                    pagedState: pagedState,
                    onRefresh: {
                        onRefresh?()
                    },
                    didRefresh: { }
                )
        }
    }
}

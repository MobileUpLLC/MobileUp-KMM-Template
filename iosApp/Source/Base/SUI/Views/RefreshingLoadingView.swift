//
//  RefreshingLoadingView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 21.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct RefreshingLoadingView<Content: View, T: AnyObject>: View {
    @ObservedObject var loadableState: ObservableState<LoadableState<T>>
    
    let content: (T) -> Content
    let onRefresh: Closure.Void
    
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            if loadableState.value.loading && isRefreshing == false {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            if let data = loadableState.value.data {
                content(data)
            } else if let error = loadableState.value.error {
                GeometryReader { proxy in
                    ScrollView {
                        HStack {
                            Spacer()
                            Text(error.localized())
                            Spacer()
                        }
                        .padding(.top, proxy.size.height / 2 - 15)
                    }
                }
            }
        }
        .animation(.easeIn, value: loadableState.value.loading)
        .animation(.easeIn, value: loadableState.value.error != nil)
        .refreshable(
            loadingState: loadableState,
            onRefresh: {
                isRefreshing = true
                
                onRefresh()
            },
            didRefresh: { isRefreshing = false }
        )
    }
}

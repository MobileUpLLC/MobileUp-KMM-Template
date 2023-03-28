//
//  LoadingView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 21.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct LoadingView<Content: View, T: AnyObject>: View {
    @ObservedObject var loadableState: ObservableState<LoadableState<T>>
    
    let content: (T) -> Content
    
    var body: some View {
        ZStack {
            if let data = loadableState.value.data {
                content(data)
            } else if let error = loadableState.value.error {
                Text(error.localized())
            }
            
            if loadableState.value.loading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .animation(.easeIn, value: loadableState.value.loading)
        .animation(.easeIn, value: loadableState.value.error != nil)
    }
}

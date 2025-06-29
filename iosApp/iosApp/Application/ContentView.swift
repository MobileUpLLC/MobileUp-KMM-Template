//
//  ContentView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 31.03.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var rootHolder: RootHolder
    @State private var isAnimationFinished = false
    
    var body: some View {
        if isAnimationFinished {
            RootView(component: rootHolder.rootComponent)
                .addToastGlobal { item in ToastView(item: item) }
        } else {
            SplashView { isAnimationFinished = true }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RootHolder())
}

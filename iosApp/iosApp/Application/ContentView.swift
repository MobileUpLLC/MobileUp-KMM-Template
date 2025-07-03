//
//  ContentView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 31.03.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var rootHolder: RootHolder
    @State private var isLaunchFinished = false
    
    var body: some View {
        ZStack {
            if isLaunchFinished {
                RootView(component: rootHolder.rootComponent)
                    .addToastGlobal { item in ToastView(item: item) }
                    .transition(.opacity)
            } else {
                SplashView(onAnimationFinished: { isLaunchFinished = true })
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RootHolder())
        .environmentObject(ToastRouter())
}

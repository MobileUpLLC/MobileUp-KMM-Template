//
//  iosAppApp.swift
//  iosApp
//
//  Created by Denis Dmitriev on 31.03.2025.
//

import SwiftUI

@main
struct iosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var rootHolder = RootHolder()
    @StateObject private var toastRouter: ToastRouter = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rootHolder)
                .environmentObject(toastRouter)
        }
    }
}

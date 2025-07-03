//
//  iosAppApp.swift
//  iosApp
//
//  Created by Denis Dmitriev on 31.03.2025.
//

import SwiftUI

@main
// swiftlint:disable:next type_name
struct iosAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var navigationModel = NavigationModel()
    @StateObject private var rootHolder = RootHolder()
    @StateObject private var toastRouter = ToastRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rootHolder)
                .environmentObject(toastRouter)
                .environmentObject(navigationModel)
        }
    }
}

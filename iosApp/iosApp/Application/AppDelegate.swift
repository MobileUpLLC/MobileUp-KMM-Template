//
//  AppDelegate.swift
//  iosApp
//
//  Created by Denis Dmitriev on 31.03.2025.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    // swiftlint:disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppearanceService.setupNavigationBar()
        AppearanceService.setupTabBar()
        
        return true
    }
}

//
//  AppDelegate.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.05.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppearanceService.setup()

        return true
    }
}

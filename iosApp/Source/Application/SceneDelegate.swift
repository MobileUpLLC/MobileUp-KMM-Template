//
//  SceneDelegate.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 05.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.rootViewController = RootController()
    }
}

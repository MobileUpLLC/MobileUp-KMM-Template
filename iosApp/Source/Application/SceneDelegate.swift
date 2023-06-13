//
//  SceneDelegate.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.05.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
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
        window?.backgroundColor = .white
        
        window?.rootViewController = SplashController { [weak self] in
            self?.updateWindow()
        }
        
        window?.makeKeyAndVisible()
    }
    
    private func updateWindow() {
        guard let window else {
            return
        }
        
        window.rootViewController = RootController()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {})
    }
}

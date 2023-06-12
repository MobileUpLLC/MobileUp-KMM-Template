//
//  AppearanceService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 22.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import UIKit

enum AppearanceService {
    static func setup() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        
        // Change font for specific project style
        // navigationBarAppearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 15)]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = .black
    }
}

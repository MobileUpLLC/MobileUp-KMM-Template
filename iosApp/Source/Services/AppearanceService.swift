//
//  AppearanceService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 22.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

enum AppearanceService {
    static func setup() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    }
}

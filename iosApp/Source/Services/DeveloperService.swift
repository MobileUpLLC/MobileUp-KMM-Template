//
//  DeveloperService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 07.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

enum DeveloperService {
    enum Messages {
        static let childOverrideFunc = "This method should be overridden in the child class"
        static let initHasNotBeenImplemented = "init(coder:) has not been implemented"
        static let noViewControllers = "No viewControllers for StackNavigationController"
        static let cannotCastTab = "Warning: Cannot cast tab viewController to HomeTabViewController"
        static let cannotCastModifiedView = "Cannot cast SwiftUI view to ModifiedContent"
    }
}

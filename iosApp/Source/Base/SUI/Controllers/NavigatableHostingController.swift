//
//  NavigatableHostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

class NavigatableHostingController<Content: View>: HostingController<Content>, StackViewController, Navigatable {
    var navigationBarModel: NavigationBarModel = .default { didSet { setupNavBar() } }
    var isNavigationBarHidden: Bool { false }
    var isLastInStack: (() -> Bool)?
    var onBack: Closure.Void?
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBarVisibility()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent && isLastInStack?() == true {
            onBack?()
        }
    }
}
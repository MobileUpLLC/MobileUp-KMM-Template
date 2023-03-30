//
//  NavigatableHostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

class NavigatableHostingController<T: AnyObject, Content: View>: UIHostingController<Content> {
    private weak var coordinator: StackViewCoordinator<T, Content>?
    private var component: T?
    private var onBack: (() -> Void)?
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = navigationBarItem.mode
//        navigationItem.title = navigationBarItem.title
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent && coordinator?.preservedComponents.last === component {
            onBack?()
        }
    }
    
    func setup(
        coordinator: StackViewCoordinator<T, Content>?,
        component: T?,
        onBack: (() -> Void)?
    ) {
        self.coordinator = coordinator
        self.component = component
        self.onBack = onBack
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

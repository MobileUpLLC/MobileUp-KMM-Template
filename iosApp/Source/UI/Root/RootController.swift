//
//  RootController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.05.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI
import Combine

class RootController: SuperHostingController<RootView> {
    private let component: RootComponent
    private var rootHolder = RootHolder()
    
    init() {
        self.component = rootHolder.rootComponent
        
        super.init(rootView: RootView(component: component))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootHolder.onViewAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        rootHolder.onViewDisappear()
    }
}

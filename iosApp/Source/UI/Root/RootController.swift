//
//  RootController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 05.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

class RootController: HostingController<RootView> {
    private var rootHolder = RootHolder()
    
    init() {
        super.init(rootView: RootView(component: rootHolder.rootComponent, rootHolder: rootHolder))
    }
}

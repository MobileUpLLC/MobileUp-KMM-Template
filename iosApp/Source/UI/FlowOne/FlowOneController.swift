//
//  FlowOneController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 06.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class FlowOneController: StackNavigationController<Flow1ComponentChild> {
    init(component: Flow1Component) {
        super.init(
            stackState: ObservableState(component.childStack)
        ) { child in
            switch child {
            case let screen1A as Flow1ComponentChild.Screen1A:
                return ScreenOneAController(component: screen1A.component)
            case let screen1B as Flow1ComponentChild.Screen1B:
                return ScreenOneBController(component: screen1B.component)
            case let screen1C as Flow1ComponentChild.Screen1C:
                return ScreenOneCController(component: screen1C.component)
            default:
                return nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

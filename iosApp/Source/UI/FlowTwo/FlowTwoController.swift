//
//  FlowTwoController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 06.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class FlowTwoController: StackNavigationController<Flow2ComponentChild> {
    init(component: Flow2Component) {
        super.init(
            stackState: ObservableState(component.childStack)
        ) { child in
            switch child {
            case let screen1A as Flow2ComponentChild.Screen2A:
                return ScreenTwoAController(component: screen1A.component)
            case let screen1B as Flow2ComponentChild.Screen2B:
                return ScreenTwoBController(component: screen1B.component)
            case let screen1C as Flow2ComponentChild.Screen2C:
                return ScreenTwoCController(component: screen1C.component)
            default:
                return nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

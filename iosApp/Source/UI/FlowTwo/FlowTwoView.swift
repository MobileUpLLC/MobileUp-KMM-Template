//
//  FlowTwoView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FlowTwoView: View {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, Flow2ComponentChild>>
    
    private let component: Flow2Component
    
    init(component: Flow2Component) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        StackView(
            stackState: childStack,
            childScreen: { child in
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
        )
    }
}

struct FlowTwoView_Previews: PreviewProvider {
    static var previews: some View {
        FlowTwoView(component: FakeFlow2Component())
    }
}

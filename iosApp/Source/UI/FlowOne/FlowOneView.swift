//
//  FlowOneView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct FlowOneView: View {
    let component: Flow1Component
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, Flow1ComponentChild>>
    
    init(component: Flow1Component) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        StackView(
            stackState: childStack,
            childScreen: { child in
                switch child {
                case let screen1A as Flow1ComponentChild.Screen1A:
                    return ScreenOneAController(component: screen1A.component)
                case let screen1B as Flow1ComponentChild.Screen1B:
                    return ScreenOneBController(component: screen1B.component)
                case let screen1C as Flow1ComponentChild.Screen1C:
                    return ScreenOneCController(component: screen1C.component)
                }
            }
        )
    }
}

struct FlowOneView_Previews: PreviewProvider {
    static var previews: some View {
        FlowOneView(component: FakeFlow1Component())
    }
}

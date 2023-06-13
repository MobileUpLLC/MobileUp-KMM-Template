//
//  ScreenTwoAView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct ScreenTwoAView: View {
    private let component: Screen2AComponent
    
    init(component: Screen2AComponent) {
        self.component = component
    }
    
    var body: some View {
        Button(MR.strings().common_next.desc().localized()) {
            component.onNextClick()
        }
    }
}

struct ScreenTwoAView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwoAView(component: FakeScreen2AComponent())
    }
}

//
//  ScreenOneAView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct ScreenOneAView: View {
    private let component: Screen1AComponent
    
    init(component: Screen1AComponent) {
        self.component = component
    }
    
    var body: some View {
        Button(MR.strings().common_next.desc().localized()) {
            component.onNextClick()
        }
        .navigationTitle(component.title.value.localized())
    }
}

struct ScreenOneAView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenOneAView(component: FakeScreen1AComponent())
    }
}

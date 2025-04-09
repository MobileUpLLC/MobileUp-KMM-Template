//
//  ScreenTwoBView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct ScreenTwoBView: View {
    private let component: Screen2BComponent
    
    init(component: Screen2BComponent) {
        self.component = component
    }
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.2)
                .ignoresSafeArea()
            Button(MR.strings().common_next.desc().localized()) {
                component.onNextClick()
            }
        }
        .navigationTitle(component.text.value.localized())
    }
}

struct ScreenTwoBView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwoBView(component: FakeScreen2BComponent())
    }
}

//
//  ScreenTwoCView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct ScreenTwoCView: View {
    private let component: Screen2CComponent
    
    init(component: Screen2CComponent) {
        self.component = component
    }
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2)
                .ignoresSafeArea()
            Button(MR.strings().common_finish.desc().localized()) {
                component.onFinishClick()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(component.text.value.localized())
    }
}

#Preview {
    ScreenTwoCView(component: FakeScreen2CComponent())
}

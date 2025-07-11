//
//  ScreenOneCView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct ScreenOneCView: View {
    private let component: Screen1CComponent
    
    init(component: Screen1CComponent) {
        self.component = component
    }
    
    var body: some View {
        Button(MR.strings().common_finish.desc().localized()) {
            component.onFinishClick()
        }
        .buttonStyle(.borderedProminent)
        .navigationTitle(component.title.value.localized())
    }
}

#Preview {
    ScreenOneCView(component: FakeScreen1CComponent())
}

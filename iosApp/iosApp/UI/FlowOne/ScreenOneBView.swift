//
//  ScreenOneBView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct ScreenOneBView: View {
    private let component: Screen1BComponent
    
    init(component: Screen1BComponent) {
        self.component = component
    }
    
    var body: some View {
        Button(MR.strings().common_next.desc().localized()) {
            component.onNextClick()
        }
        .buttonStyle(.borderedProminent)
        .navigationTitle(component.title.value.localized())
    }
}

#Preview {
    ScreenOneBView(component: FakeScreen1BComponent())
}

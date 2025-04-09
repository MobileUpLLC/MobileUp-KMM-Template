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
        ZStack {
            Color.red.opacity(0.2)
                .ignoresSafeArea()
            Button(MR.strings().common_next.desc().localized()) {
                component.onNextClick()
            }
        }
        .navigationTitle(component.text.value.localized())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    BackDispatcherService.shared.backDispatcher.back()
                } label: {
                    Image(systemName: "xmark")
                }

            }
        }
    }
}

#Preview {
    ScreenTwoAView(component: FakeScreen2AComponent())
}

//
//  TabTwoView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct TabTwoView: View {
    private let component: Tab2Component
    
    init(component: Tab2Component) {
        self.component = component
    }
    
    var body: some View {
        NavigationStack {
            Button(MR.strings().home_tab2_start_flow2_button.desc().localized()) {
                component.onStartFlow2Click()
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle(component.text.value.localized())
        }
    }
}

#Preview {
    TabTwoView(component: FakeTab2Component())
}

//
//  TabTwoView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TabTwoView: View {
    private let component: Tab2Component
    
    init(component: Tab2Component) {
        self.component = component
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(component.text.value.localized())
            
            Button(MR.strings().home_tab2_start_flow2_button.desc().localized()) {
                component.onStartFlow2Click()
            }
        }
    }
}

struct TabTwoView_Previews: PreviewProvider {
    static var previews: some View {
        TabTwoView(component: FakeTab2Component())
    }
}

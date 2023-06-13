//
//  TabOneView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct TabOneView: View {
    private let component: Tab1Component
    
    init(component: Tab1Component) {
        self.component = component
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(component.text.value.localized())
            
            Button(MR.strings().common_exit.desc().localized()) {
                component.onExitClick()
            }
        }
    }
}

struct TabOneView_Previews: PreviewProvider {
    static var previews: some View {
        TabOneView(component: FakeTab1Component())
    }
}

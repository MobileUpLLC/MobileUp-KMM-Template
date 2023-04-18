//
//  ScreenTwoCView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 29.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct ScreenTwoCView: View {
    private let component: Screen2CComponent
    
    init(component: Screen2CComponent) {
        self.component = component
    }
    
    var body: some View {
        Button(MR.strings().common_finish.desc().localized()) {
            component.onFinishClick()
        }
    }
}

struct ScreenTwoCView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwoCView(component: FakeScreen2CComponent())
    }
}

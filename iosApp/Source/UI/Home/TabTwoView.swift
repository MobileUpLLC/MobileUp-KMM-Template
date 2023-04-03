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
        Text("Tab Two")
    }
}

struct TabTwoView_Previews: PreviewProvider {
    static var previews: some View {
        TabTwoView(component: FakeTab2Component())
    }
}

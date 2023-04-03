//
//  TabOneView.swift
//  iosApp
//
//  Created by VGrokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TabOneView: View {
    private let component: Tab1Component
    
    init(component: Tab1Component) {
        self.component = component
    }
    
    var body: some View {
        Text("Tab One")
    }
}

struct TabOneView_Previews: PreviewProvider {
    static var previews: some View {
        TabOneView(component: FakeTab1Component())
    }
}

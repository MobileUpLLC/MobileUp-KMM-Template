//
//  HomeView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    let component: HomeComponent
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, HomeComponentChild>>
    
    init(component: HomeComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(component: FakeHomeComponent())
    }
}

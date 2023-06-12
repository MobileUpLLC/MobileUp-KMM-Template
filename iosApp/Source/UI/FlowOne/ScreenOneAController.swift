//
//  ScreenOneAController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

final class ScreenOneAController: NavigatableHostingController<ScreenOneAView> {
    init(component: Screen1AComponent) {
        super.init(rootView: ScreenOneAView(component: component))
        
        navigationBarModel = NavigationBarModel(
            infoToolbarItem: .init(item: .title(component.title.value.localized())),
            isLargeTitle: true
        )
    }
}

struct ScreenOneAControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScreenOneAController {
        return ScreenOneAController(component: FakeScreen1AComponent())
    }
    
    func updateUIViewController(_ uiViewController: ScreenOneAController, context: Context) {}
}

struct ScreenOneAControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        ScreenOneAControllerPreview()
    }
}

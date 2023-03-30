//
//  ScreenTwoAController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class ScreenTwoAController: NavigatableHostingController<Screen2AComponent, ScreenTwoAView> {
    init(component: Screen2AComponent) {
        super.init(rootView: ScreenTwoAView(component: component))
        
//        navigationBarModel = NavigationBarModel(
//            infoToolbarItem: .init(item: .title(component.text.value.localized())),
//            isLargeTitle: true
//        )
    }
}

struct ScreenTwoAControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScreenTwoAController {
        return ScreenTwoAController(component: FakeScreen2AComponent())
    }
    
    func updateUIViewController(_ uiViewController: ScreenTwoAController, context: Context) {}
}

struct ScreenTwoAControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwoAControllerPreview()
    }
}

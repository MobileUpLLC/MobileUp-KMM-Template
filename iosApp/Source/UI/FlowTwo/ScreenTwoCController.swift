//
//  ScreenTwoCController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class ScreenTwoCController: NavigatableHostingController<Screen2CComponent, ScreenTwoCView> {
    init(component: Screen2CComponent) {
        super.init(rootView: ScreenTwoCView(component: component))
        
//        navigationBarModel = NavigationBarModel(
//            infoToolbarItem: .init(item: .title(component.text.value.localized())),
//            isLargeTitle: true
//        )
    }
}

struct ScreenTwoCControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScreenTwoCController {
        return ScreenTwoCController(component: FakeScreen2CComponent())
    }
    
    func updateUIViewController(_ uiViewController: ScreenTwoCController, context: Context) {}
}

struct ScreenTwoCControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwoCControllerPreview()
    }
}

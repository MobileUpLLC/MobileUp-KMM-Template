//
//  ScreenOneCController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

final class ScreenOneCController: NavigatableHostingController<ScreenOneCView> {
    init(component: Screen1CComponent) {
        super.init(rootView: ScreenOneCView(component: component))
        
        navigationBarModel = NavigationBarModel(
            infoToolbarItem: .init(item: .title(component.title.value.localized())),
            isLargeTitle: true
        )
    }
}

struct ScreenOneCControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScreenOneCController {
        return ScreenOneCController(component: FakeScreen1CComponent())
    }
    
    func updateUIViewController(_ uiViewController: ScreenOneCController, context: Context) {}
}

struct ScreenOneCControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        ScreenOneCControllerPreview()
    }
}

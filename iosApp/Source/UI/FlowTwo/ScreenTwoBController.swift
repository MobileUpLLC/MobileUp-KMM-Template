//
//  ScreenTwoBController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class ScreenTwoBController: NavigatableHostingController<ScreenTwoBView> {
    init(component: Screen2BComponent) {
        super.init(rootView: ScreenTwoBView(component: component))
        
        navigationBarModel = NavigationBarModel(
            infoToolbarItem: .init(item: .title(component.text.value.localized())),
            isLargeTitle: true
        )
    }
}

struct ScreenTwoBControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScreenTwoBController {
        return ScreenTwoBController(component: FakeScreen2BComponent())
    }
    
    func updateUIViewController(_ uiViewController: ScreenTwoBController, context: Context) {}
}

struct ScreenTwoBControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTwoBControllerPreview()
    }
}

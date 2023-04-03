//
//  ScreenOneBController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 30.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

final class ScreenOneBController: NavigatableHostingController<ScreenOneBView> {
    init(component: Screen1BComponent) {
        super.init(rootView: ScreenOneBView(component: component))
        
        navigationBarModel = NavigationBarModel(
            infoToolbarItem: .init(item: .title(component.title.value.localized())),
            isLargeTitle: true
        )
    }
}

struct ScreenOneBControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScreenOneBController {
        return ScreenOneBController(component: FakeScreen1BComponent())
    }
    
    func updateUIViewController(_ uiViewController: ScreenOneBController, context: Context) {}
}

struct ScreenOneBControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        ScreenOneBControllerPreview()
    }
}

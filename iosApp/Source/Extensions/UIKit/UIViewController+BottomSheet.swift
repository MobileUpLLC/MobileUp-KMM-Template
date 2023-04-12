//
//  UIViewController+BottomSheet.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import BottomSheet
import UIKit

extension UIViewController {
    func presentAsBottomSheet(_ controller: UIViewController) {
        controller.view.layoutIfNeeded()
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        controller.preferredContentSize = controller.view.systemLayoutSizeFitting(targetSize)
        
        presentBottomSheet(
            viewController: controller,
            configuration: .default
        )
    }
}

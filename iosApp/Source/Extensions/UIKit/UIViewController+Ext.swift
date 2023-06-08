//
//  UIViewController+Ext.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

extension UIViewController {
    func updatePresentedBottomSheetHeight() {
        let screenSize = UIScreen.main.bounds
        let targetSize = CGSize(width: screenSize.width, height: UIView.layoutFittingExpandedSize.height)
        
        var size = view.systemLayoutSizeFitting(targetSize)
        let safeArea = UIApplication.getSafeAreaInsets()
        size.height -= safeArea.bottom
        
        UIView.animate(withDuration: 0.4) {
            self.preferredContentSize = size
        }
    }
}

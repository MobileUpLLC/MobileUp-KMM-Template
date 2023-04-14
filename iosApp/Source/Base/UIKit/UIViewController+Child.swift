//
//  UIViewController+Child.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 05.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

extension UIViewController {
    private enum Constants {
        static let fadeAnimationDuration = 0.5
    }
    
    func addChild(controller: UIViewController) {
        view.layoutSubview(controller.view, safe: false)
        addChild(controller)
        
        controller.view.alpha = .zero
        
        UIView.animate(withDuration: Constants.fadeAnimationDuration) {
            controller.view.alpha = .one
        }
    }

    func removeChild(controller: UIViewController?) {
        guard controller?.parent != nil else {
            return
        }
        
        UIView.animate(
            withDuration: Constants.fadeAnimationDuration,
            animations: {
                controller?.view.alpha = .zero
            },
            completion: { finished in
                if finished {
                    controller?.willMove(toParent: nil)
                    controller?.removeFromParent()
                    controller?.view.removeFromSuperview()
                }
            }
        )
    }
}

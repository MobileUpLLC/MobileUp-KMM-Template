//
//  BottomSheetPresentable.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 18.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import BottomSheet
import UIKit

typealias BottomSheetTransitioningDelegate = BottomSheet.BottomSheetTransitioningDelegate
typealias BottomSheetSupportable = BottomSheetPresentationControllerFactory & BottomSheetModalDismissalHandler

protocol BottomSheetPresentable: UIViewController, BottomSheetSupportable {
    var transitionDelegate: BottomSheetTransitioningDelegate? { get set }
    var canBottomSheetBeDismissed: Bool { get }
    
    func presentAsBottomSheet(_ controller: UIViewController)
}

extension BottomSheetPresentable {
    var canBeDismissed: Bool { canBottomSheetBeDismissed }
    
    func performDismissal(animated: Bool) {
        transitionDelegate = nil
        
        presentedViewController?.dismiss(animated: animated)
    }
    
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        BottomSheetPresentationController(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self,
            configuration: .default
        )
    }
    
    func presentAsBottomSheet(_ controller: UIViewController) {
        transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        
        setPreferredContentSize(controller)
        present(controller, animated: true, completion: nil)
    }
    
    private func setPreferredContentSize(_ controller: UIViewController) {
        controller.view.layoutIfNeeded()
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        controller.preferredContentSize = controller.view.systemLayoutSizeFitting(targetSize)
    }
}

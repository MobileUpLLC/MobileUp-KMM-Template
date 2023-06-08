//
//  HostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 18.04.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI
import BottomSheet

typealias ModifiedWithWrapper<T: View> = _EnvironmentKeyWritingModifier<HostWrapper<T>?>
typealias ModifiedWithWrapperContent<T: View> = ModifiedContent<T, ModifiedWithWrapper<T>>

final class HostWrapper<T: View>: ObservableObject {
    weak var controller: HostingController<T>?
}

class HostingController<T: View>: UIHostingController<ModifiedWithWrapperContent<T>> {
    weak var parentController: UIViewController?
    
    init(rootView: T) {
        let container = HostWrapper<T>()
        let hostingAccessingView = rootView.environmentObject(container)
        
        guard let modified = hostingAccessingView as? ModifiedWithWrapperContent<T> else {
            fatalError(DeveloperService.Messages.cannotCastModifiedView)
        }
        
        super.init(rootView: modified)
        
        container.controller = self
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class SuperHostingController<T: View>: UIViewController, BottomSheetPresentable {
    var transitionDelegate: BottomSheetTransitioningDelegate?
    var canBottomSheetBeDismissed: Bool { true }
    let controller: HostingController<T>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMove(toParent: self)
        controller.parentController = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // removing strong references from presenting controller to call deinit
        performDismissal(animated: true)
    }
    
    init(rootView: T) {
        controller = HostingController(rootView: rootView)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        fatalError(DeveloperService.Messages.initHasNotBeenImplemented)
    }
}

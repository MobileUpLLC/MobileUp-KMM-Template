//
//  HostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import BottomSheet

typealias ModifiedWithWrapper<T: View> = _EnvironmentKeyWritingModifier<HostWrapper<T>?>
typealias ModifiedWithWrapperContent<T: View> = ModifiedContent<T, ModifiedWithWrapper<T>>

final class HostWrapper<T: View>: ObservableObject {
    weak var controller: HostingController<T>?
}

class HostingController<T: View>: UIHostingController<ModifiedWithWrapperContent<T>>, BottomSheetPresentable {
    var transitionDelegate: BottomSheetTransitioningDelegate?
    var canBottomSheetBeDismissed: Bool { true }
    
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

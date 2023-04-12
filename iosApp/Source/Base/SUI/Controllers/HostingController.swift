//
//  HostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

typealias ModifiedWithWrapper = _EnvironmentKeyWritingModifier<HostWrapper?>

final class HostWrapper: ObservableObject {
    weak var controller: UIViewController?
}

class HostingController<T: View>: UIHostingController<ModifiedContent<T, ModifiedWithWrapper>> {
    init(rootView: T) {
        let container = HostWrapper()
        let hostingAccessingView = rootView.environmentObject(container)
        
        guard let modified = hostingAccessingView as? ModifiedContent<T, ModifiedWithWrapper> else {
            fatalError(DeveloperService.Messages.cannotCastModifiedView)
        }
        
        super.init(rootView: modified)
        
        container.controller = self
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

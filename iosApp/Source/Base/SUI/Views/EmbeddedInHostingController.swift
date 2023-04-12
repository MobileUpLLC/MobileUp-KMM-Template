//
//  EmbeddedInHostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 12.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

extension View {
    func embedded<T: View>(
        in hostingController: UIHostingController<ModifiedContent<T, ModifiedWithWrapper>>
    ) -> ModifiedContent<T, ModifiedWithWrapper> {
        let container = HostWrapper()
        container.controller = hostingController
        
        let hostingAccessingView = environmentObject(container)
        
        guard let viewToReturn = hostingAccessingView as? ModifiedContent<T, ModifiedWithWrapper> else {
            fatalError(DeveloperService.Messages.cannotCastModifiedView)
        }
        
        return viewToReturn
    }
}

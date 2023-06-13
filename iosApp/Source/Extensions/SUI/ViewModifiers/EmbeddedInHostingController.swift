//
//  EmbeddedInHostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 12.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

extension View {
    func embedded<T: View>(
        in hostingController: HostingController<T>
    ) -> ModifiedWithWrapperContent<T> {
        let container = HostWrapper<T>()
        container.controller = hostingController
        
        let hostingAccessingView = environmentObject(container)
        
        guard let viewToReturn = hostingAccessingView as? ModifiedWithWrapperContent<T> else {
            fatalError(DeveloperService.Messages.cannotCastModifiedView)
        }
        
        return viewToReturn
    }
}

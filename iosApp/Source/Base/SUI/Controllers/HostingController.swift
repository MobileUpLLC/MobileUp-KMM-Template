//
//  HostingController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

class HostingController<T: View>: UIHostingController<T> {
    override init(rootView: T) {
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable) @MainActor dynamic required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

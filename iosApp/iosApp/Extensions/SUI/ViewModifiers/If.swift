//
//  If.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 05.06.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI

extension View {
    // Be careful using in Foreach, could have some troubles with id
    @ViewBuilder func `if`<Content: View>(
        _ condition: @autoclosure () -> Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

//
//  Hidden.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 26.04.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        modifier(HiddenModifier(isHidden: isHidden))
    }
}

private struct HiddenModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        if isHidden {
            content
                .hidden()
        } else {
            content
        }
    }
}

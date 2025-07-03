//
//  Library+Destination.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

extension Shared.Flow1Component.Child.__Sealed: @unchecked @retroactive Sendable, Destinationable {
    @MainActor @ViewBuilder
    func destination(for item: Self) -> some View {
        switch item {
        case .screen1A(let value):
            ScreenOneAView(component: value.component)
        case .screen1B(let value):
            ScreenOneBView(component: value.component)
        case .screen1C(let value):
            ScreenOneCView(component: value.component)
        }
    }
}

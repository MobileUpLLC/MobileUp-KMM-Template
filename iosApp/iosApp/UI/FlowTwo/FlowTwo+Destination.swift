//
//  Library+Destination.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

extension Shared.Flow2Component.Child.__Sealed: @unchecked @retroactive Sendable, Destinationable {
    @MainActor @ViewBuilder
    func destination(for item: Self) -> some View {
        switch item {
        case .screen2A(let value):
            ScreenTwoAView(component: value.component)
        case .screen2B(let value):
            ScreenTwoBView(component: value.component)
        case .screen2C(let value):
            ScreenTwoCView(component: value.component)
        }
    }
}

//
//  Main+Destination.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

extension Shared.HomeComponent.Child.__Sealed: @unchecked @retroactive Sendable, Destinationable {
    @MainActor @ViewBuilder
    func destination(for item: Self) -> some View {
        switch item {
        case .tab1(let value):
            TabOneView(component: value.component)
        case .tab2(let value):
            TabTwoView(component: value.component)
        case .tab3(let value):
            PokemonView(component: value.component)
        }
    }
}

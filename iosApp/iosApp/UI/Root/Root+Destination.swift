//
//  Root+Destination.swift
//  iosApp
//
//  Created by kursor on 30.06.2025.
//
import SwiftUI

extension Shared.RootComponent.Child.__Sealed: @unchecked @retroactive Sendable, Destinationable {
    @MainActor @ViewBuilder
    func destination(for item: Self) -> some View {
        switch item {
        case .flow1(let value):
            FlowOneView(component: value.component)
        case .flow2(let value):
            FlowTwoView(component: value.component)
        case .home(let value):
            HomeView(component: value.component)
        }
    }
}


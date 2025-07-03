//
//  NavigationModel.swift
//  iosApp
//
//  Created by Denis Dmitriev on 12.05.2025.
//

import Foundation

@MainActor
final class NavigationModel: ObservableObject {
    @Published var path: [Router] = []
    @Published var previousPath: [Router] = []
}

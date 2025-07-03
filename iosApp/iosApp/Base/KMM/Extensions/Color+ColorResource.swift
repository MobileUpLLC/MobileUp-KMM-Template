//
//  Color+ColorResource.swift
//  iosApp
//
//  Created by Denis Dmitriev on 20.05.2025.
//

import SwiftUI

extension Color {
    /// Инициализирует `SwiftUI.Color` из `ColorResource` KMM.
    /// - Parameter kmm: Ресурс цвета из KMM.
    public init(kmm: shared.ColorResource) {
        self.init(uiColor: kmm.getUIColor())
    }
}

//
//  Color+GraphicsColor.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

extension Color {
    static func graphicsColor(_ graphicsColor: GraphicsColor) -> Self {
        return Color(
            red: Double(graphicsColor.red) / 255,
            green: Double(graphicsColor.green) / 255,
            blue: Double(graphicsColor.blue) / 255,
            opacity: Double(graphicsColor.alpha) / 255
        )
    }
}

extension GraphicsColor {
    var color: Color {
        Color(
            red: Double(self.red) / 255,
            green: Double(self.green) / 255,
            blue: Double(self.blue) / 255,
            opacity: Double(self.alpha) / 255
        )
    }
}

extension Color {
    init(hex: UInt32) {
        let hasAlpha = (hex >> 24) > 0
        let a, r, g, b: UInt32

        if hasAlpha {
            r = (hex >> 16) & 0xFF
            g = (hex >> 8) & 0xFF
            b = (hex >> 0) & 0xFF
            a = hex & 0xFF
        } else {
            r = (hex >> 16) & 0xFF
            g = (hex >> 8) & 0xFF
            b = (hex >> 0) & 0xFF
            a = 255
        }

        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: Double(a) / 255.0
        )
    }
}

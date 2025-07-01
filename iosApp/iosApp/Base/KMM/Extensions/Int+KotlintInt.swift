//
//  Int+KotlintInt.swift
//  iosApp
//
//  Created by Denis Dmitriev on 21.05.2025.
//

import Foundation

extension Int {
    /// Инициализирует `Swift.Int` из `KotlinInt` KMM.
    /// - Parameter kmm: Целое число из KMM.
    init(kmm: KotlinInt) {
        self.init(kmm.intValue)
    }
}

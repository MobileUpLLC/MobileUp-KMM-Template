//
//  Bool+KotlinBoolean.swift
//  iosApp
//
//  Created by Denis Dmitriev on 21.05.2025.
//

import Foundation

extension Bool {
    /// Инициализирует `Swift.Bool` из `KotlinBoolean` KMM.
    /// - Parameter kmm: Булево значение из KMM.
    init(kmm: KotlinBoolean) {
        self.init(kmm.boolValue)
    }
}

//
//  Float_KotlinFloat.swift
//  iosApp
//
//  Created by Denis Dmitriev on 21.05.2025.
//

import Foundation

extension Float {
    /// Инициализирует `Swift.Double` из `KotlinFloat` KMM.
    /// - Parameter kmm: Число с плавающей точкой из KMM.
    init(kmm: KotlinFloat) {
        self.init(kmm.floatValue)
    }
}

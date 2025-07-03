//
//  Double+KotlinDouble.swift
//  iosApp
//
//  Created by Denis Dmitriev on 21.05.2025.
//

import Foundation

extension Double {
    /// Инициализирует `Swift.Double` из `KotlinDouble` KMM.
    /// - Parameter kmm: Число с плавающей точкой из KMM.
    init(kmm: KotlinDouble) {
        self.init(kmm.doubleValue)
    }
}

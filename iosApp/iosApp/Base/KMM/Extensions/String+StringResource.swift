//
//  String+StringResource.swift
//  iosApp
//
//  Created by Denis Dmitriev on 21.05.2025.
//

import Foundation

extension String {
    /// Инициализирует `Swift.String` из `StringResource` KMM с поддержкой локализации.
    /// - Parameter kmm: Строковый ресурс из KMM.
    init(kmm: shared.StringResource) {
        self.init(kmm.desc().localized())
    }
    
    /// Инициализирует `Swift.String` из `StringResource` KMM с форматированием строки.
    /// - Parameters:
    ///   - kmm: Строковый ресурс из KMM, содержащий шаблон для форматирования.
    ///   - format: Массив аргументов для подстановки в шаблон строки.
    init(kmm: shared.StringResource, format: KotlinArray<AnyObject>) {
        self.init(kmm.format(args: format).localized())
    }
}

//
//  AnyHashable+PathUtils.swift
//  iosApp
//
//  Created by Denis Dmitriev on 07.04.2025.
//

import Foundation

extension AnyHashable {
    /// Возвращает строковое представление пути на основе имени класса.
    ///
    /// Используется для получения читаемой информации о конкретном шаге навигации
    /// — например, имени экрана или типа маршрута.
    ///
    /// - Parameter count: Количество компонентов в конце пути, которые нужно оставить.
    ///                    Например, `1` даст только имя типа, `2` — модуль и имя типа.
    /// - Returns: Краткое строковое описание назначения, например: `"MainScreen"` или `"App.MainScreen"`.
    public func pathDescription(count: Int = 1) -> String {
        guard let classPart = String(describing: self).components(separatedBy: "@").first else {
            return "Empty destination"
        }
        
        let destination: String = classPart.components(separatedBy: ".")
            .suffix(count)
            .joined(separator: ".")
        
        return destination
    }
    
    public func getUrl() -> String {
        guard let classPart = self.description.components(separatedBy: "@").first else {
            return "Empty destination"
        }
        
        let destination: String = classPart.components(separatedBy: ".")
            .joined(separator: "/")
        
        return destination
    }
}

extension Array where Element == AnyHashable {
    /// Генерирует строковое описание всего пути навигации.
    ///
    /// Объединяет описания всех элементов массива `AnyHashable`, представляющих
    /// путь в `NavigationStack` или аналогичной системе, в одну строку.
    ///
    /// - Parameter count: Количество компонентов в каждом элементе пути.
    /// - Returns: Строка, описывающая весь путь, например: `"MainScreen -> DetailScreen -> SettingsScreen"`.
    public func pathDescription(count: Int = 1) -> String {
        var result: [String] = []
        
        for element in self {
            result.append(element.pathDescription(count: count))
        }
        
        return result.joined(separator: " -> ")
    }
}

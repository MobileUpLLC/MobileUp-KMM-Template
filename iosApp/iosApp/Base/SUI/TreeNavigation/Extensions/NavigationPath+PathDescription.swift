//
//  NavigationPath+State.swift
//  iosApp
//
//  Created by Denis Dmitriev on 08.04.2025.
//

import SwiftUI

extension NavigationPath {
    /// Возвращает строковое описание текущего пути навигации.
    ///
    /// Анализирует внутреннее содержимое `NavigationPath` с помощью `Mirror` и отображает
    /// последовательность типов, находящихся в пути. Это полезно для отладки навигации.
    ///
    /// - Returns: Строка, описывающая путь, например: `"MainScreen -> DetailScreen -> SettingsScreen"`,
    ///            или `"NavigationPath is empty"`, если путь пуст.
    var pathDescription: String {
        let mirror = Mirror(reflecting: self)
        
        var result: [String] = []
        
        for child in mirror.children {
            if let label = child.label, label == "_items" {
                let itemsMirror = Mirror(reflecting: child.value)
                for itemChild in itemsMirror.children {
                    let itemMirror = Mirror(reflecting: itemChild.value)
                    for element in itemMirror.children {
                        let typeDescription = String(describing: type(of: element.value))
                        if let typeName = extractTypeName(from: typeDescription) {
                            result.append(typeName)
                        }
                    }
                }
            }
        }
        
        if result.isEmpty {
            return "NavigationPath is empty"
        } else {
            return result.joined(separator: " -> ")
        }
    }
    
    /// Извлекает имя типа из строки вида `ItemBox<TypeName>`.
    ///
    /// Используется для отображения типов в `pathDescription`.
    ///
    /// - Parameter input: Строка, содержащая тип.
    /// - Returns: Извлечённое имя типа, если найдено, иначе `nil`.
    private func extractTypeName(from input: String) -> String? {
        let pattern = #"ItemBox<([^>]+)>"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: input, range: NSRange(input.startIndex..., in: input)),
           let range = Range(match.range(at: 1), in: input) {
            return String(input[range])
        }
        return nil
    }
}

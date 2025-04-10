//
//  NavigationPath+State.swift
//  iosApp
//
//  Created by Denis Dmitriev on 08.04.2025.
//

import SwiftUI

extension NavigationPath {
    /// Состояние изменения навигационного пути между двумя состояниями.
    enum State {
        /// Элемент был добавлен — переход вперёд.
        case push
        /// Элемент был удалён — переход назад.
        case pop
        /// Путь очищен — возвращение к корню.
        case popToRoot
        /// Невозможно определить изменение — нестандартная модификация.
        case empty
    }
    
    /// Определяет тип изменения между предыдущим и текущим состоянием пути.
    ///
    /// Используется для определения, было ли выполнено `push`, `pop` или `popToRoot` на `NavigationPath`.
    ///
    /// - Parameter fromPath: Предыдущее состояние навигационного пути.
    /// - Returns: Значение `State`, отражающее тип изменения пути.
    func getState(fromPath: [AnyHashable]) -> State {
        let fromPath = fromPath.dropFirst() // Удаляем базовый компонент, так как в SwiftUI path не содержит базовый элемент
        if self.count - fromPath.count == 1 {
            return .push
        } else if fromPath.count - self.count == 1 {
            return .pop
        } else if self.count == 0 {
            return .popToRoot
        } else {
            return .empty
        }
    }
}

extension NavigationPath {
    /// Полностью очищает навигационный путь.
    ///
    /// Эквивалентно `popToRoot()`, удаляет все элементы из пути.
    mutating func removeAll() {
        self.removeLast(self.count)
    }
}

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

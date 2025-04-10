//
//  NavigationState.swift
//  iosApp
//
//  Created by Denis Dmitriev on 07.04.2025.
//

import Foundation

/// Состояние навигации, отражающее текущее изменение маршрута.
///
/// Используется для описания различных действий навигации в приложении —
/// переходов, возвратов, замены стека и т.д. Также поддерживает текстовое описание для отладки.
enum NavigationState: CustomStringConvertible {
    /// Установка корневого элемента маршрута.
    case root(AnyHashable)
    
    /// Переход вперёд к новому экрану.
    case push(AnyHashable)
    
    /// Возврат на один экран назад.
    case pop
    
    /// Возврат к корневому экрану.
    case popToRoot
    
    /// Неопределённое состояние — может использоваться как заглушка или ошибка.
    case empty
    
    /// Полная замена текущего стека маршрута.
    case replace([AnyHashable])
    
    /// Строковое представление текущего состояния навигации.
    ///
    /// Используется, например, для логирования маршрутов.
    var description: String {
        switch self {
        case .root(let root):
            return "🏁 \(root.pathDescription())"
        case .push(let item):
            return "▶️ \(item.pathDescription())"
        case .pop:
            return "◀️"
        case .popToRoot:
            return "⏮️"
        case .empty:
            return "⁉️"
        case .replace:
            return "🔄"
        }
    }
}

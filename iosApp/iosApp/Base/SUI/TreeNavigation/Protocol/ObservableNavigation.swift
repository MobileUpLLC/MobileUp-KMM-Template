//
//  ObservableNavigation.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

/**
 * Протокол для управления навигацией в SwiftUI с использованием `NavigationPath` и `flatPath`.
 *
 * Этот протокол предоставляет общие методы и свойства для классов, которые управляют
 * навигацией в приложении, обеспечивая синхронизацию навигационных состояний между KMM
 * и SwiftUI, используя два стека: `navigationPath` (для SwiftUI) и `flatPath` (для KMM).
 *
 * С помощью этого протокола классы могут отслеживать изменения навигации и передавать их
 * между платформами (KMM и SwiftUI), чтобы синхронизировать состояние навигации в обоих направлениях.
 *
 * Основные методы:
 * - `syncPath(state:type:)`: Синхронизирует путь навигации с новым состоянием (например, push, pop).
 */
protocol ObservableNavigation: ObservableObject {
    var navigationPath: NavigationPath { get set }
    var flatPath: [AnyHashable] { get set }
    
    func syncPath<Destination: AnyObject & Hashable>(state: NavigationState, type: Destination.Type)
}

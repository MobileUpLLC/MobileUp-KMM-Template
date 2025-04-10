//
//  RootTreeNavigation.swift
//  iosApp
//
//  Created by Denis Dmitriev on 09.04.2025.
//

import SwiftUI

/**
 * `RootTreeNavigation` — это модификатор представлений для установки начальной навигации в дереве компонентов.
 * Он используется для синхронизации состояния навигации с моделью навигации на основе текущего стека дочерних элементов.
 *
 * Модификатор отслеживает, когда представление появляется на экране, и, если навигационный путь ещё пуст (например, это корневое представление),
 * отправляет сигнал в модель навигации для синхронизации пути с первым элементом в текущем стеке дочерних компонентов.
 * Это позволяет обеспечить правильную инициализацию навигации для корневого элемента.
 *
 * Свойства:
 * - `childStack`: Объект типа `ObservableState<ChildStack<C, Destination>>`, который представляет текущий стек дочерних компонентов для навигации.
 * - `navigationModel`: Объект, соответствующий протоколу `ObservableNavigation`, который управляет навигационным состоянием и взаимодействует с навигацией.
 */
struct RootTreeNavigation<C: AnyObject, Destination: Hashable & AnyObject>: ViewModifier {
    /// Стек дочерних компонентов для текущего контекста.
    @ObservedObject var childStack: ObservableState<ChildStack<C, Destination>>
    
    /// Модель навигации, управляющая состоянием навигации.
    let navigationModel: any ObservableNavigation
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if
                    navigationModel.flatPath.isEmpty,
                    let root = childStack.value.items.compactMap({ $0.instance }).first
                {
                    navigationModel.syncPath(state: .root(root), type: type(of: root))
                }
            }
    }
}

extension View {
    /**
     * Расширение для `View`, которое добавляет метод для применения модификатора `RootTreeNavigation`.
     * Это расширение упрощает использование модификатора в представлениях, добавляя удобный способ привязки
     * стека дочерних компонентов и модели навигации.
     *
     * Этот метод позволяет применить `RootTreeNavigation` к любому представлению, обеспечивая синхронизацию
     * пути навигации с начальным элементом в стеке дочерних компонентов.
     *
     * - Parameter childStack: Стек дочерних компонентов, для которых нужно синхронизировать навигацию.
     * - Parameter navigationModel: Модель навигации, которая управляет текущим состоянием навигации.
     * - Returns: Модифицированное представление, которое теперь имеет функциональность навигации.
     */
    func setRootTreeNavigation<C: AnyObject, Destination: Hashable & AnyObject>(
        childStack: ObservableState<ChildStack<C, Destination>>,
        navigationModel: any ObservableNavigation
    ) -> some View {
        self.modifier(
            RootTreeNavigation(
                childStack: childStack,
                navigationModel: navigationModel
            )
        )
    }
}

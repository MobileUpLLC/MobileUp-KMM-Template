//
//  TreeNavigationModifier.swift
//  iosApp
//
//  Created by Denis Dmitriev on 04.04.2025.
//

import SwiftUI

/**
 * `TreeNavigationModifier` — это модификатор для навигации в дереве компонентов, который использует модель навигации для синхронизации и отслеживания изменений в навигационном пути.
 *
 * Модификатор выполняет следующую роль:
 * - Следит за изменениями в стеке дочерних компонентов (через `childStack`).
 * - На основе изменений в стеке определяет, нужно ли обновить навигационный путь.
 * - Вызывает методы синхронизации пути навигации через модель навигации (`navigationModel.syncPath`).
 * - Строит представление для целевой компоненты (через `destinationBuilder`).
 *
 * Свойства:
 * - `childStack`: Объект типа `ObservableState<ChildStack<C, Destination>>`, который представляет текущий стек дочерних компонентов для навигации.
 * - `navigationModel`: Объект, соответствующий протоколу `ObservableNavigation`, который управляет состоянием навигации и взаимодействует с навигацией.
 * - `destinationBuilder`: Замыкание для построения представления целевой компоненты типа `Destination`, которое будет отображено при навигации.
 *
 * Методы:
 * - `body(content:)`: Основной метод для модификации содержимого, добавляя логику для отслеживания изменений в стеке и синхронизации с моделью навигации.
 */
struct TreeNavigationModifier<C: AnyObject, Destination: Hashable & AnyObject, DestinationView: View>: ViewModifier {
    /// Стек дочерних компонентов для текущего контекста.
    @ObservedObject var childStack: KotlinStateFlow<ChildStack<C, Destination>>
    
    /// Модель навигации, управляющая состоянием навигации.
    var navigationModel: any ObservableNavigation
    
    /// Замыкание для построения представления для целевой компоненты.
    let destinationBuilder: (Destination) -> DestinationView
    
    init(
        childStack: KotlinStateFlow<ChildStack<C, Destination>>,
        navigationModel: any ObservableNavigation,
        destinationBuilder: @escaping (Destination) -> DestinationView
    ) {
        self._childStack = .init(wrappedValue: childStack)
        self.navigationModel = navigationModel
        self.destinationBuilder = destinationBuilder
    }
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Destination.self) { destinationBuilder($0) }
            // MARK: Важно использовать именно `onReceive(_:perform:)` вместо `onChange(of:perform:)`
            .onReceive(_childStack.wrappedValue.$wrappedValue) { newStack in
                var fromPath = navigationModel.flatPath.compactMap { $0 as? Destination }
                let toPath = newStack.items.map(\.instance)

                // Если корневой элемент отсутствует в путях, добавляем его в начало пути
                if
                    let rootItem = childStack.wrappedValue.items.map(\.instance).first,
                    fromPath.first != rootItem,
                    toPath.last != rootItem
                {
                    fromPath.insert(rootItem, at: 0)
                }
                guard fromPath.isEmpty == false else {
                    return
                }
                
                guard fromPath != toPath else {
                    return
                }
                
                // Определяем состояние навигации и синхронизируем путь
                let state = getDestinationState(fromPath: fromPath, toPath: toPath)
                
                let message = "-------\n"
                + "🧭 \(type(of: Destination.self)) \(state)\n"
                + "From: \(getPathDescription(path: fromPath))\n"
                + "To: \(getPathDescription(path: toPath))\n"
                Log.navigation.debug(logEntry: .text(message))
                
                // Синхронизация пути с моделью навигации
                navigationModel.syncPath(state: state, type: Destination.self)
            }
    }
    
    /**
     * Определяет состояние навигации, основываясь на текущем и целевом пути.
     *
     * - Parameters:
     *   - fromPath: Текущий путь навигации.
     *   - toPath: Новый путь навигации.
     * - Returns: Состояние навигации, которое будет передано в модель навигации.
     */
    private func getDestinationState(fromPath: [Destination], toPath: [Destination]) -> NavigationState {
        if toPath.count == 1, let rootItem = toPath.first {
            return .root(rootItem)
        } else if fromPath.count < toPath.count, let lastItem = toPath.last {
            return .push(AnyHashable(lastItem))
        } else if fromPath.count > toPath.count {
            return .pop
        } else if fromPath.count > 2, toPath.count == 1 {
            return .popToRoot
        } else {
            return .empty
        }
    }
    
    /**
     * Формирует строковое представление пути навигации.
     *
     * - Parameter path: Путь навигации, представленный массивом объектов типа `Destination`.
     * - Returns: Строковое представление пути.
     */
    private func getPathDescription(path: [Destination]) -> String {
        return path.map({ $0 as AnyHashable }).pathDescription(count: 3)
    }
}

extension View {
    /**
     * Модификатор TreeNavigationModifier`.
     * Это расширение упрощает использование модификатора в представлениях, добавляя удобный способ привязки
     * стека дочерних компонентов и модели навигации.
     *
     * Этот метод позволяет применить `TreeNavigationModifier` к любому представлению, обеспечивая синхронизацию
     * пути навигации с текущими элементами в стеке дочерних компонентов.
     *
     * - Parameter childStack: Стек дочерних компонентов, для которых нужно синхронизировать навигацию.
     * - Parameter navigationModel: Модель навигации, которая управляет текущим состоянием навигации.
     * - Parameter destination: Замыкание для построения представления для целевой компоненты.
     * - Returns: Модифицированное представление, которое теперь имеет функциональность навигации.
     */
    func treeNavigation<C: AnyObject, Destination: Hashable & AnyObject, DestinationView: View>(
        childStack: KotlinStateFlow<ChildStack<C, Destination>>,
        navigationModel: any ObservableNavigation,
        destination: @escaping (Destination) -> DestinationView
    ) -> some View {
        self.modifier(
            TreeNavigationModifier(
                childStack: childStack,
                navigationModel: navigationModel,
                destinationBuilder: destination
            )
        )
    }
}

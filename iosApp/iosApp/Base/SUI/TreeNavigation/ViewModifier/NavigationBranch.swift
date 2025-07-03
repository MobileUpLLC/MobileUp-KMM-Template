//
//  NavigationBranch.swift
//  iosApp
//
//  Created by Denis Dmitriev on 14.05.2025.
//

import SwiftUI

/// Обработчик обновления стека из KMM навигации для ветки
///
/// Требуется вешать его на каждую новую ветку (узел).
struct NavigationBranch<C: AnyObject, Destination: Hashable & AnyObject>: ViewModifier {
    /// Состояния изменения стека
    private enum StackChange {
        /// Добавление нового элемента
        case push(Router)
        
        /// Удаление всей ветки до корня
        case popBranch
        
        /// Удаление до определенного элемента
        ///
        /// Эквивалентно удалению всех элементов до указанного индекса с сохранением элемента по этому индексу.
        /// Например, если `branchPath = [A, B, C, D]` и `newItems = [A, B]`,
        /// то `index = 1`, и удаляются элементы после `B` (т.е. `C` и `D`).
        case popToLeaf(index: Int)
        
        /// Полная замена стека
        case replaceStack([Router])
        
        /// Перемещение листа на конец стека
        case moveForward(Router)
        
        /// Нет изменений
        case none
    }
    
    @EnvironmentObject var navigationModel: NavigationModel
    
    /// Стек дочерних компонентов (листьев) для текущего узла.
    @ObservedObject var childStack: KotlinStateFlow<ChildStack<C, Destination>>
    var cast: (Destination) -> Router
    
    /// Путь на ветке навигации в SwiftUI
    private var branchPath: [Router] {
        [root] + navigationModel.path.branch(by: root)
    }
    
    /// Путь на ветке навигации в KMM
    private var branchStack: [Router] {
        childStack.wrappedValue.items.map({ item in cast(item.instance) })
    }
    
    /// Листок в начале ветки
    private var root: Router {
        childStack.wrappedValue.items.map({ item in cast(item.instance) }).first ?? .empty
    }
    
    init(
        childStack: KotlinStateFlow<ChildStack<C, Destination>>,
        cast: @escaping (Destination) -> Router
    ) {
        self.childStack = childStack
        self.cast = cast
    }
    
    func body(content: Content) -> some View {
        content
            /// Обновление навигации из изменений ветки KMM
            /// - Attention: `.onChange(of: _childStack.wrappedValue.wrappedValue)` не срабатывает на глубине 2+
            .onReceive(childStack.$wrappedValue, perform: { newValue in
                // Приведем к понятному типу перечисления
                let newItems = newValue.items.map({ item in cast(item.instance) })
                // Определим состояние
                let stackChange = detectStackChange(newItems: newItems)
                // Применим изменения
                applyStackChange(stackChange)
            })
    }
    
    /// Определяет состояние изменения стека
    private func detectStackChange(newItems: [Router]) -> StackChange {
        guard branchPath != newItems else {
            return .none // Изменения не требуются
        }
        
        /* TODO: Нужно согласовать переход с KMP модулем навигации
        if let pushItem = newItems.last, branchPath.contains(pushItem), branchPath.first != pushItem {
            return .moveForward(pushItem)
        }
         */
        
        if branchPath.count < newItems.count, let pushItem = newItems.last {
            return .push(pushItem) // Новый элемент будет добавлен
        }
        
        if branchPath.count > newItems.count, let removeBefore = branchPath.lastIndex(of: newItems.last ?? root) {
            if removeBefore == 0 {
                return .popBranch // Удаляем всю ветку
            } else {
                return .popToLeaf(index: removeBefore) // Удаляем до определенного элемента
            }
        }
        
        // Полная замена стека, если последний элемент newItems не найден в branchPath
        return .replaceStack(Array(newItems.drop(while: { router in router.isFromSameBranch(leaf: root) })))
    }
    
    /// Применяет изменение стека
    ///
    /// - Attention: Важно сначала обновлять `previousPath`, а затем `path`,
    /// чтобы избежать ложного срабатывания логики "назад" при **пользовательском** взаимодействии.
    private func applyStackChange(_ change: StackChange) {
        switch change {
        case .push(let router):
            navigationModel.path.append(router)
            
        case .popBranch:
            let countToRemove = min(branchPath.count, navigationModel.path.count)
            let forRemoval = branchPath.dropFirst(branchPath.count - countToRemove)
            var newPreviousPath = Array(navigationModel.previousPath)
            var newPath = Array(navigationModel.path)
            forRemoval.forEach({ it in
                newPreviousPath = newPreviousPath.removeWithChildren(branch: it)
                newPath = newPath.removeWithChildren(branch: it)
            })
            navigationModel.previousPath = newPreviousPath
            navigationModel.path = newPath
            
        case .popToLeaf(let index):
            let lastItemIndex = branchPath.count
            let countToRemove = min(lastItemIndex - index, navigationModel.path.count)
            navigationModel.previousPath.removeLast(countToRemove)
            navigationModel.path.removeLast(countToRemove)
            
        case .replaceStack(let newItems):
            let countToRemove = min(branchPath.count, navigationModel.path.count)
            let forRemoval = branchPath.dropFirst(branchPath.count - countToRemove)
            var newPreviousPath = Array(navigationModel.previousPath)
            var newPath = Array(navigationModel.path)
            forRemoval.forEach({ it in
                newPreviousPath = newPreviousPath.removeWithChildren(branch: it)
                newPath = newPath.removeWithChildren(branch: it)
            })
            newPreviousPath.append(contentsOf: newItems)
            newPath.append(contentsOf: newItems)
            navigationModel.previousPath = newPreviousPath
            navigationModel.path = newPath
            
        case .moveForward(let item):
            guard let index = navigationModel.path.firstIndex(of: item) else {
                break
            }
            navigationModel.previousPath.remove(at: index)
            navigationModel.path.remove(at: index)
            navigationModel.previousPath.append(item)
            navigationModel.path.append(item)
            
        case .none:
            break
        }
    }
}

extension View {
    /// Обработчик состояния узла навигации
    ///
    /// - Parameters:
    ///   - childStack: ChildStack листьями для этой ветки навигации.
    ///   - cast: Замыкание чтоб привести тип Objective-C в Swift Enum для данной ветки навигации.
    ///   Нужно использовать Skie сгенерированный код `func onEnum<__Sealed>(of sealed: __Sealed)`
    ///
    /// - Attention: Требует наличия `NavigationModel` в среде `EnvironmentObject`
    func navigationBranch<C: AnyObject, Destination: Hashable & AnyObject>(
        childStack: KotlinStateFlow<ChildStack<C, Destination>>,
        cast: @escaping (Destination) -> Router
    ) -> some View {
        self.modifier(
            NavigationBranch(childStack: childStack, cast: cast)
        )
    }
}

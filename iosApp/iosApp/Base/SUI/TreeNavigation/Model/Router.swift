//
//  Router.swift
//  iosApp
//
//  Created by Denis Dmitriev on 12.05.2025.
//

import SwiftUI

protocol Destinationable {
    associatedtype Content: View
    @MainActor @ViewBuilder func destination(for item: Self) -> Content
}

typealias Shared = shared.Skie.Shared

enum Router: Hashable, Equatable, Sendable, Identifiable, CustomStringConvertible {
    case empty
    
    typealias RootComponent = Shared.RootComponent.Child.__Sealed
    case root(RootComponent)
    
    typealias Flow1Component = Shared.Flow1Component.Child.__Sealed
    case flow1(Flow1Component)
    
    typealias Flow2Component = Shared.Flow2Component.Child.__Sealed
    case flow2(Flow2Component)
    
    typealias HomeComponent = Shared.HomeComponent.Child.__Sealed
    case home(HomeComponent)
    
    typealias PokemonsComponent = Shared.PokemonsComponent.Child.__Sealed
    case pokemons(PokemonsComponent)
    
    @MainActor @ViewBuilder
    static func destination(for item: Self) -> some View {
        switch item {
        case .empty:
            EmptyView()
        case .root(let router):
            router.destination(for: router)
        case .flow1(let router):
            router.destination(for: router)
        case .flow2(let router):
            router.destination(for: router)
        case .home(let router):
            router.destination(for: router)
        case .pokemons(let router):
            router.destination(for: router)
        }
    }
    
    var id: String {
        (self as AnyHashable).pathDescription(count: 5)
    }
    
    var description: String {
        switch self {
        case .empty:
            return "empty"
        case .flow1(let value):
            switch value {
            case .screen1A:
                return "flow1.screen1A"
            case .screen1B:
                return "flow1.screen1B"
            case .screen1C:
                return "flow1.screen1C"
            }
        case .flow2(let value):
            switch value {
            case .screen2A:
                return "flow2.screen2A"
            case .screen2B:
                return "flow2.screen2B"
            case .screen2C:
                return "flow2.screen2C"
            }
        case .home(let value):
            switch value {
            case .tab1:
                return "home.tab1"
            case .tab2:
                return "home.tab2"
            case .tab3:
                return "home.tab3"
            }
        case .pokemons(let value):
            switch value {
            case .details:
                return "pokemons.details"
            case .list:
                return "pokemons.list"
            }
        case .root(let value):
            switch value {
            case .flow1:
                return "root.flow1"
            case .flow2:
                return "root.flow2"
            case .home:
                return "root.home"
            }
        }
    }
}

extension Router {
    init(component: AnyObject) {
        switch component {
        case let component as RootComponentChild:
            self = .root(onEnum(of: component))
        case let component as Flow1ComponentChild:
            self = .flow1(onEnum(of: component))
        case let component as Flow2ComponentChild:
            self = .flow2(onEnum(of: component))
        case let component as HomeComponentChild:
            self = .home(onEnum(of: component))
        case let component as PokemonsComponentChild:
            self = .pokemons(onEnum(of: component))
        default:
            fatalError(#function + ": unsupported component \(String(describing: component))")
        }
    }
}

extension Router {
    func isFromSameBranch(leaf: Self) -> Bool {
        switch (self, leaf) {
        case (.root, .root):
            return true
        case (.flow1, .flow1):
            return true
        case (.flow2, .flow2):
            return true
        case (.home, .home):
            return true
        case (.pokemons, .pokemons):
            return true
        default:
            return false
        }
    }
    
    func isLeafFrom(branch: Self) -> Bool {
        switch (self, branch) {
        case (.flow1, .root):
            return true
        case (.flow2, .root):
            return true
        case (.home, .root):
            return true
        case (.pokemons, .home):
            return true
        default:
            return false
        }
    }
}

extension Array<Router> {
    /// Фильтрует стек навигации с конца, возвращая непрерывную последовательность элементов,
    /// принадлежащих той же ветке, что и `leaf`. Прерывает фильтрацию при встрече элемента
    /// из другой ветки после нахождения первого подходящего элемента.
    /// - Parameter leaf: Элемент `Router`, определяющий ветку для фильтрации.
    /// - Returns: Отфильтрованный массив элементов той же ветки в порядке стека.
    func branch(by leaf: Router) -> Self {
        var result: [Router] = []
        
        // Проходим по массиву с конца
        for element in self.reversed() {
            // Проверяем, принадлежит ли элемент той же ветке, что и leaf
            if element.isFromSameBranch(leaf: leaf) {
                result.append(element)
            } else if result.isEmpty == false {
                // Если встретили элемент из другой ветки после подходящих, прерываем
                break
            }
        }
        
        // Возвращаем результат в правильном порядке (разворачиваем обратно)
        return result.reversed()
    }
    
    func removeWithChildren(branch: Router) -> Self {
        return self.filter({ router in
            let shouldBeLeft = router.isLeafFrom(branch: branch) || router == branch
            return shouldBeLeft == false
        })
    }
}

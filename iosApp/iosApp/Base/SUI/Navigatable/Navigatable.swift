//
//  Navigatable.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

protocol TreeNavigation {
    associatedtype C: AnyObject
    associatedtype Destination: AnyObject & Hashable
    associatedtype Content: View
//    associatedtype NavigationModel: ObservableNavigation
    
    var childStack: ObservableState<ChildStack<C, Destination>> { get set }
    
    func destination(for item: Destination) -> Content
}

extension TreeNavigation {
    /// Исходное представление в массиве навигации или нулевой элемент массива
    @ViewBuilder var rootView: some View {
        if let value = childStack.value.items.compactMap({ $0.instance }).first {
            destination(for: value)
        } else {
            EmptyView()
        }
    }
    
    /*
    func getState(fromPath: [Destination], toPath: [Destination]) -> NavigationState {
        if fromPath.count == toPath.count {
            return .empty
        } else if fromPath.count < toPath.count, let lastItem = toPath.last {
            return .push(lastItem)
        } else if fromPath.count > toPath.count {
            return .pop
        } else if fromPath.count > 2, toPath.count == 1 {
            return .popToRoot
        } else {
            return .empty
        }
    }
     */
}

// Заменить на TreeNavigation
protocol Navigatable {
    associatedtype C: AnyObject
    associatedtype T: AnyObject & Hashable
    associatedtype Content: View
    
    var childStack: ObservableState<ChildStack<C, T>> { get set }
    var path: Binding<[AnyHashable]> { get }
    
    func destination(for item: AnyHashable) -> Content
}

extension Navigatable {
    var path: Binding<[AnyHashable]> {
        Binding(
            get: { childStack.value.items.dropFirst().map { $0.instance } },
            set: { path in
                /// Если стек стал на 1 меньше, то значит был переход назад
                if path.count == childStack.value.items.dropFirst().map({ $0.instance }).count - 1 {
                    BackDispatcherService.shared.backDispatcher.back()
                }
            }
        )
    }
    
    @ViewBuilder
    var rootView: some View {
        if let value = childStack.value.items.compactMap({ $0.instance }).first {
            destination(for: value)
        } else {
            EmptyView()
        }
    }
}

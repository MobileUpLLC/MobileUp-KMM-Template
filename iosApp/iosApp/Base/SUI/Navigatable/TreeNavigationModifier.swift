//
//  TreeNavigationModifier.swift
//  iosApp
//
//  Created by Denis Dmitriev on 04.04.2025.
//

import SwiftUI

struct TreeNavigationModifier<C: AnyObject, Destination: Hashable & AnyObject, DestinationView: View>: ViewModifier {
    @ObservedObject var childStack: ObservableState<ChildStack<C, Destination>>
    var navigationModel: any ObservableNavigation
    let destinationBuilder: (Destination) -> DestinationView
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Destination.self) { destinationBuilder($0) }
            // MARK: Важно использовать именно `onReceive(_:perform:)` вместо `onChange(of:perform:)`
            .onReceive(childStack.$value) { newStack in
                var fromPath = navigationModel.flatPath.compactMap { $0 as? Destination }
                let toPath = newStack.items.map(\.instance)
                if
                    let rootItem = childStack.value.items.map(\.instance).first,
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
                
                let state = getDestinationState(fromPath: fromPath, toPath: toPath)
                
                let message = "-------\n"
                + "🧭 \(type(of: Destination.self)) \(state)\n"
                + "From: \(getPathDescription(path: fromPath))\n"
                + "To: \(getPathDescription(path: toPath))\n"
                Log.navigation.debug(logEntry: .text(message))
                
                navigationModel.syncPath(state: state, type: Destination.self)
            }
    }
    
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
    
    private func getPathDescription(path: [Destination]) -> String {
        return path.map({ $0 as AnyHashable }).pathDescription(count: 3)
    }
}

extension View {
    func treeNavigation<C: AnyObject, Destination: Hashable & AnyObject, DestinationView: View>(
        childStack: ObservableState<ChildStack<C, Destination>>,
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

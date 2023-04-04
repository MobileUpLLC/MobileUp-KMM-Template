import SwiftUI

struct NavigationBarItem {
    let title: String
    let mode: UINavigationItem.LargeTitleDisplayMode
    
    static let `default` = NavigationBarItem(title: .empty, mode: .never)
}

protocol StackViewController: UIViewController {
    var isLastInStack: (() -> Bool)? { get set }
    var onBack: Closure.Void? { get set }
    
    func setup(isLastInStack: @escaping () -> Bool, onBack: @escaping Closure.Void)
}

extension StackViewController {
    func setup(isLastInStack: @escaping () -> Bool, onBack: @escaping Closure.Void) {
        self.isLastInStack = isLastInStack
        self.onBack = onBack
    }
}

// Base idea is got from from Decompose sample
// https://github.com/arkivanov/Decompose/blob/master/sample/app-ios/app-ios/StackView.swift
struct StackView<T: AnyObject>: UIViewControllerRepresentable {
    @ObservedObject var stackState: ObservableState<ChildStack<AnyObject, T>>
    
    var childScreen: (T) -> StackViewController?
    var components: [T] { stackState.value.items.compactMap { $0.instance } }
    
    private let onBack: Closure.Void = { BackDispatcherService.shared.backDispatcher.back() }
    
    func makeCoordinator() -> StackViewCoordinator<T> {
        return StackViewCoordinator<T>()
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.syncChanges(self)
        
        guard let rootViewController = context.coordinator.viewControllers.first else {
            return UINavigationController()
        }
        
        return UINavigationController(rootViewController: rootViewController)
    }
    
    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        context.coordinator.syncChanges(self)
        navigationController.setViewControllers(context.coordinator.viewControllers, animated: true)
    }
    
    func createViewController(_ component: T, _ coordinator: Coordinator) -> UIViewController {
        guard let controller = childScreen(component) else {
            return UIViewController()
        }
        
        controller.setup { [weak coordinator, weak component] in
            return coordinator?.preservedComponents.last === component
        } onBack: {
            onBack()
        }
        
        return controller
    }
}

class StackViewCoordinator<T: AnyObject>: NSObject {
    var viewControllers: [UIViewController] = []
    var preservedComponents: [T] = []
    
    func syncChanges(_ parent: StackView<T>) {
        let count = max(preservedComponents.count, parent.components.count)
        
        for i in 0..<count {
            if i >= parent.components.count {
                viewControllers.removeLast()
            } else if i >= preservedComponents.count {
                viewControllers.append(parent.createViewController(parent.components[i], self))
            } else if parent.components[i] !== preservedComponents[i] {
                viewControllers[i] = parent.createViewController(parent.components[i], self)
            }
        }
        
        preservedComponents = parent.components
    }
}

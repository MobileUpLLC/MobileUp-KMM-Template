import SwiftUI

struct NavigationBarItem {
    let title: String
    let mode: UINavigationItem.LargeTitleDisplayMode
    
    static let `default` = NavigationBarItem(title: .empty, mode: .never)
}

// Base idea is got from from Decompose sample
// https://github.com/arkivanov/Decompose/blob/master/sample/app-ios/app-ios/StackView.swift
struct StackView<T: AnyObject, Content: View>: UIViewControllerRepresentable {
    @ObservedObject var stackState: ObservableState<ChildStack<AnyObject, T>>
    
    var childScreen: (T) -> NavigatableHostingController<T, Content>
    var components: [T] { stackState.value.items.compactMap { $0.instance } }
    
    private let onBack: Closure.Void = { BackDispatcherService.shared.backDispatcher.back() }
    
    func makeCoordinator() -> StackViewCoordinator<T, Content> {
        StackViewCoordinator(self)
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
    
    func createViewController(
        _ component: T,
        _ coordinator: Coordinator
    ) -> NavigatableHostingController<T, Content> {
        // Наследник от BaseHostingController, SomeHostingController(component) в зависимости от компонента
        let controller = childScreen(component)
        
        controller.setup(
            coordinator: coordinator,
            component: component,
            onBack: onBack
        )
        
        return controller
    }
}

class StackViewCoordinator<T: AnyObject, Content: View>: NSObject {
    var parent: StackView<T, Content>
    var viewControllers = [NavigatableHostingController<T, Content>]()
    var preservedComponents = [T]()
    
    init(_ parent: StackView<T, Content>) {
        self.parent = parent
    }
    
    func syncChanges(_ parent: StackView<T, Content>) {
        self.parent = parent
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

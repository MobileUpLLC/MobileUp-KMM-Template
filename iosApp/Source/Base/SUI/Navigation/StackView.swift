import SwiftUI

// Code from Decompose sample
// https://github.com/arkivanov/Decompose/blob/master/sample/app-ios/app-ios/StackView.swift
struct StackView<T: AnyObject, Content: View>: View {
    @ObservedObject var stackState: ObservableState<ChildStack<AnyObject, T>>

    var getTitle: (T) -> String = { _ in return .empty }
    
    @ViewBuilder
    var childContent: (T) -> Content
    
    var stack: [Child<AnyObject, T>] { stackState.value.items }
    
    private let onBack: () -> Void = {
        BackDispatcherService.shared.backDispatcher.back()
    }
    
    var body: some View {
        StackInteropView(
            components: stack.compactMap { $0.instance },
            getTitle: getTitle,
            onBack: onBack,
            childContent: childContent
        )
    }
}

private struct StackInteropView<T: AnyObject, Content: View>: UIViewControllerRepresentable {
    var components: [T]
    var getTitle: (T) -> String
    var onBack: () -> Void
    var childContent: (T) -> Content
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        context.coordinator.syncChanges(self)
        
        guard let rootViewController = context.coordinator.viewControllers.first else {
            return UINavigationController()
        }
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        context.coordinator.syncChanges(self)
        navigationController.setViewControllers(context.coordinator.viewControllers, animated: true)
    }
    
    private func createViewController(_ component: T, _ coordinator: Coordinator) -> NavigationItemHostingController {
        let controller = NavigationItemHostingController(rootView: childContent(component))
        controller.coordinator = coordinator
        controller.component = component
        controller.onBack = onBack
        controller.navigationItem.title = getTitle(component)
        
        return controller
    }
    
    class Coordinator: NSObject {
        var parent: StackInteropView<T, Content>
        var viewControllers = [NavigationItemHostingController]()
        var preservedComponents = [T]()
        
        init(_ parent: StackInteropView<T, Content>) {
            self.parent = parent
        }
        
        func syncChanges(_ parent: StackInteropView<T, Content>) {
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
    
    class NavigationItemHostingController: UIHostingController<Content> {
        fileprivate(set) weak var coordinator: Coordinator?
        fileprivate(set) var component: T?
        fileprivate(set) var onBack: (() -> Void)?
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            if isMovingFromParent && coordinator?.preservedComponents.last === component {
                onBack?()
            }
        }
    }
}

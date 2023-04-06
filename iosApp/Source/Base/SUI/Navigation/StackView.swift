import SwiftUI
import Combine

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

struct StackView<T: AnyObject>: UIViewControllerRepresentable {
    @ObservedObject var stackState: ObservableState<ChildStack<AnyObject, T>>
    var childScreen: (T) -> StackViewController?
    
    func makeUIViewController(context: Context) -> StackNavigationController<T> {
        return StackNavigationController(stackState: stackState, childScreen: childScreen)
    }
    
    func updateUIViewController(_ navigationController: StackNavigationController<T>, context: Context) {}
}

class StackNavigationController<T: AnyObject>: UINavigationController {
    @ObservedObject var stackState: ObservableState<ChildStack<AnyObject, T>>
    
    var components: [T] { stackState.value.items.compactMap { $0.instance } }
    
    private let coordinator: StackViewCoordinator<T>
    private var subscriptions: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
        updateControllers()
        
        stackState.objectWillChange.sink { [weak self] in
            DispatchQueue.main.async {
                self?.updateControllers()
            }
        }
        .store(in: &subscriptions)
=======
        createSink()
>>>>>>> 460f0bb (Fix hidesBottomBarWhenPushed)
    }
    
    init(
        stackState: ObservableState<ChildStack<AnyObject, T>>,
        childScreen: @escaping (T) -> StackViewController?
    ) {
        self.coordinator = StackViewCoordinator(childScreen: childScreen)
        self.stackState = stackState
        
        coordinator.syncChanges(stackState.value.items.compactMap { $0.instance })
        
        if let controller = coordinator.viewControllers.first {
            super.init(rootViewController: controller)
        } else {
<<<<<<< HEAD
            assertionFailure(DeveloperService.Messages.noViewControllers)
=======
>>>>>>> 460f0bb (Fix hidesBottomBarWhenPushed)
            super.init()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
<<<<<<< HEAD
        assertionFailure(DeveloperService.Messages.initHasNotBeenImplemented)
        
        return nil
    }
    
    func update(stack: CStateFlow<ChildStack<AnyObject, T>>) {
        stackState.recreate(stack)
        
        // Need it to be sure that order of methods will be
        // self.update -> self.viewWillAppear -> rootController.viewDidLoad ->
        // -> rootController.viewWillAppear -> rootController.viewDidAppear-> self.viewDidAppear
        // after fake component replacement
        viewControllers = []
        
        updateControllers(animated: false)
    }
    
    private func updateControllers(animated: Bool = true) {
        coordinator.syncChanges(components)
        setViewControllers(coordinator.viewControllers, animated: animated)
=======
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: iOS fix it, don't work well
    func update(stack: CStateFlow<ChildStack<AnyObject, T>>) {
        stackState = ObservableState(stack)
        
        updateControllers()
        createSink()
    }
    
    private func createSink() {
        subscriptions.removeAll()
        updateControllers()
        
        stackState.objectWillChange.sink { [weak self] in
            DispatchQueue.main.async {
                self?.updateControllers()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func updateControllers() {
        coordinator.syncChanges(components)
        setViewControllers(coordinator.viewControllers, animated: true)
>>>>>>> 460f0bb (Fix hidesBottomBarWhenPushed)
    }
}

class StackViewCoordinator<T: AnyObject>: NSObject {
    var childScreen: (T) -> StackViewController?
    var viewControllers: [UIViewController] = []
    
    private var preservedComponents: [T] = []
    private let onBack: Closure.Void = { BackDispatcherService.shared.backDispatcher.back() }
    
    init(childScreen: @escaping (T) -> StackViewController?) {
        self.childScreen = childScreen
    }
    
    func syncChanges(_ components: [T] ) {
        let count = max(preservedComponents.count, components.count)
        
        for i in 0..<count {
            if i >= components.count {
                viewControllers.removeLast()
            } else if i >= preservedComponents.count {
                viewControllers.append(createViewController(components[i]))
            } else if components[i] !== preservedComponents[i] {
                viewControllers[i] = createViewController(components[i])
            }
        }
        
        preservedComponents = components
    }
    
    private func createViewController(_ component: T) -> UIViewController {
        guard let controller = childScreen(component) else {
            return UIViewController()
        }
        
        controller.setup { [weak self, weak component] in
            return self?.preservedComponents.last === component
        } onBack: { [weak self] in
            self?.onBack()
        }
        
        return controller
    }
}

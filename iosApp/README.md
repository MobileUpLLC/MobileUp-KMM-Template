# KMM iOS MobileUp Template

## Project structure
```
.
├── Source
│   ├── Application
│   │   ├── AppDelegate.swift - AppDelegate to handle app state
│   │   ├── SceneDelegate.swift - Setup application scene and window.
│   │   ├── Global.swift - Global imports of shared module and Utils library.
│   │   └── RootHolder.swift - Class for life cycle management and configuration. 
│   ├── Base
│   │   ├── Foundation
│   │   │   └── CFlowWrapper.swift - to handle non-state values from Kotlin CFlow
│   │   │   └── State - The states to connect Kotlin CStateFlow with Swift ObservableObject.
│   │   │       ├── NullableObservableState.swift - State to handle optional values.
│   │   │       ├── ObservableState.swift - State to handle non optional values.
│   │   │       └── UnsafeObservableState.swift - State to handle unsafe values.
│   │   ├── SUI
│   │   │   ├── Controllers
│   │   │   │   ├── HostingController.swift - Base controller to host SUI view.
│   │   │   │   └── NavigatableHostingController.swift - Base controller to host SUI view to place in StackView and setup UIKit navigation bar.
│   │   │   ├── Navigation
│   │   │   │   └── StackView.swift - Base class to use as navigation controller.
│   │   │   └── Views - Some base views to use.
│   │   └── UIKit - Some base views to use.
│   ├── Configs
│   │   ├── Build configs
│   │   │   ├── debug.xcconfig
│   │   │   └── release.xcconfig
│   │   └── Info.plist
│   ├── Extensions
│   │   ├── Foundation
│   │   ├── SUI
│   │   │   └── ViewModifiers
│   │   │       ├── EmbeddedInHostingController.swift - Modifier for consistent redefinition of root view of hosting controller.
│   │   │       ├── LoadableWithError.swift - Modifier for handling LoadingState Kotlin-values, that can be empty, loading or error.
│   │   │       └── ScrollOnOverflow.swift - Modifier for view with dynamic height, that may contains scrollable content.
│   │   └── UIKit
│   ├── Preview Content
│   │   └── PreviewAssets.xcassets - Preview assets.
│   ├── Protocols
│   │   ├── BottomSheetPresentable.swift - Protocol for BottomSheet presenting.
│   │   └── Navigatable.swift - Protocol for navigation bar configuration.
│   ├── Resources
│   │   ├── Assets
│   │   │   ├── Assets.xcassets - Assets imported from Figma.
│   │   │   └── Images.xcassets - Assets added from Figma via manual way.
│   │   └── R.generated - Generated file to use assets.
│   ├── Services
│   │   ├── AppearanceService.swift - Service for setting custom appearance.  
│   │   ├── BackDispatcherService.swift - Service for providing Kotlin component deletion from stack.
│   │   ├── EnvironmentService.swift - Service for current enum checking.
│   │   └── DeveloperService.swift - Enum with strings for developing usage.
│   └── UI
│       ├── FlowOne
│       ├── FlowTwo
│       ├── Home
│       │   ├── HomeTabBarView.swift - Example of the tab bar usage.
│       │   └── ...
│       ├── Launch
│       ├── Pokemons - Feature example for the template.
│       │   ├── PokemonController.swift - Inheritor of StackNavigationController, provides the representation of the whole feature.
│       │   ├── PokemonListController.swift - NavigatableHostingController for hosting the Pokemon list view.
│       │   ├── PokemonListView.swift - SUI view for the Pokemon list.
│       │   ├── PokemonDetailsController.swift - NavigatableHostingController for hosting of the Pokemon details view.
│       │   ├── PokemonDetailsView.swift - SUI view for the Pokemon details.
│       │   ├── PokemonVotesController.swift - HostingController for hosting of Pokemon votes view.
│       │   └── PokemonVotesView.swift - SUI view for the Pokemon votes.
│       └── Root
│           ├── RootView.swift - The root view of the application.
│           └── RootController.swift - The root controller of the application.
├── rswift - Executable file for RSwift.
├── swiftlint.yml - SwiftLint settings file.
└── iosApp.xcodeproj
```

## Technology stack
SwiftUI, UIKit, BottomSheet, Kingfisher, Utils, R, iOS 15.1+

## Инициализация
The entry point is UIKit-flow, we use AppDelegate and SceneDelegate. In SceneDelegate set rootController. In the basic implementation we immediately added SplashScreen, which is on a separate controller, that triggers `updateWindow` func after animation. In the RootController we need to create the RootComponent, for this we use the RootHolder class, which accesses the core shared code.

```swift
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        
        window?.rootViewController = SplashController { [weak self] in
            self?.updateWindow()
        }
        
        window?.makeKeyAndVisible()
    }
    
    private func updateWindow() {
        guard let window else {
            return
        }
        
        window.rootViewController = RootController()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {})
    }
```

## RootView
`RootView` is the SUI view which represents all components in root stack dynamically base on stack changes. The stack components are represented via SUI views, one for specific flow (straight navigation usually), some kind of container for stack component child. To make it work just change the types of views (SUI views) and components (created on android side).

```swift
struct RootView: View {
    private let component: RootComponent
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    @ObservedObject private var message: NullableObservableState<Message>
    
    init(component: RootComponent) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
        self.message = NullableObservableState(component.messageComponent.visibleMessage)
    }
    
    var body: some View {
        ZStack {
            ForEach(.zero..<childStack.value.items.count, id: \.self) { index in
                ChildView(
                    child: childStack.value.items[index].instance
                )
                // To prevent views disappear transition not animated
                // https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/#solution
                .zIndex(Double(index))
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: component.childStack.value.items)
        .ignoresSafeArea()
    }
}

private struct ChildView: View {
    let child: RootComponentChild?
    
    var body: some View {
        switch child {
        case let flowOne as RootComponentChild.Flow1:
            FlowOneView(component: flowOne.component)
        case let flowTwo as RootComponentChild.Flow2:
            FlowTwoView(component: flowTwo.component)
        case let home as RootComponentChild.Home:
            HomeView(component: home.component)
        default:
            EmptyView()
        }
    }
}
```

## SuperHostingController
Base-class is used to create controllers with ability to present BottomSheets. When creating controller, use a composition of methods that replicate the logic:
- 1. Subscribe to ControlState changes
- 2. Produce `updateBottomSheetState` when ControlState changes
- 3. Produce `present`, when the component is in the expanded state
- 4. Call `control.dismiss()` in the presented controller at the moment of deinitialization

```swift
final class PokemonController: SuperHostingController<PokemonView>, HomeTabViewController {
    private var component: PokemonsComponent
    private var subscriptions: [AnyCancellable] = []
    
    @ObservedObject private var bottomSheetState: ObservableState<BottomSheetControlState>
    
    init(component: PokemonsComponent) {
        self.component = component
        self.bottomSheetState = ObservableState(component.bottomSheetControl.sheetState)
        
        super.init(rootView: PokemonView(component: component))
        
//1     bottomSheetState.objectWillChange.sink { [weak self] in
            let value = self?.bottomSheetState.value ?? .hidden
            
            DispatchQueue.main.async {
//2             self?.updateBottomSheetState(oldValue: value)
            }
        }
        .store(in: &subscriptions)
    }
    
    func update(component: HomeComponentChild) {
        ...
        
        bottomSheetState.recreate(homeChildComponent.component.bottomSheetControl.sheetState)
    }
    
    private func updateBottomSheetState(oldValue: BottomSheetControlState) {
        switch bottomSheetState.value {
        case .expanded, .halfexpanded:
            if [.expanded, .halfexpanded].contains(oldValue) {
                break
            }
            
//3         presentBottomSheet()
        case .hidden:
            if oldValue == .hidden {
                break
            }
            
            dismiss(animated: true)
        default:
            break
        }
    }
    
    private func presentBottomSheet() {
        let controller = PokemonVotesController(control: component.bottomSheetControl)
        
        presentAsBottomSheet(controller)
    }
}

final class PokemonVotesController: HostingController<PokemonVotesView> {
    private let control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>
    
    init(control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>) {
        self.control = control
        
        super.init(rootView: PokemonVotesView(control: control))
    }
    
//4 deinit {
        control.dismiss()
    }
}

```

## Navigation
Use `NavigatableHostingController` as a child viewController of tabBar (to have an ability to hide tabBar when push) or in case you need to setup UIKit Navigation Bar.

```swift
final class PokemonController: NavigatableHostingController<PokemonView>, HomeTabViewController {
    var homeTab: HomeTab { .tab3 }
    
    init(component: PokemonsComponent) {
        super.init(rootView: PokemonView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab3_label.desc().localized(),
            image: UIImage(systemName: "3.square"),
            tag: .two
        )
    }
}

struct PokemonView: View {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, PokemonsComponentChild>>
    
    init(component: PokemonsComponent) {
        childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        StackView(
            stackState: childStack,
            childScreen: { child in
                switch child {
                case let pokemonsList as PokemonsComponentChildList:
                    return PokemonListController(component: pokemonsList.component)
                case let pokemonsDetails as PokemonsComponentChildDetails:
                    let controller = PokemonDetailsController(component: pokemonsDetails.component)
                    controller.hidesBottomBarWhenPushed = true
                    
                    return controller
                default:
                    return nil
                }
            }
        )
        .ignoresSafeArea()
    }
}
```

## TabBar
To create a tabBar you should copy `HomeTabBarView` and `HomeTabBarCoordinator` and fix it to use your components and represent your screens. Actually, all you have to do is to change types, all other specific logic should not be changed.

\* Mention the `addViewController` and `update` methods of `HomeTabBarView` and `HomeTabBarCoordinator`. The mechanism of replacing/updating of child components is needed since the tabItem is the part of the viewController, we need all view controllers as tabBar children before all tabBar components are inited and placed to the stack, and the recreating of viewControllers is not good idea.

\*\* Pay attention, that in `update` method of TabOneController we use `embedded(in:)` modifier to keep access of SUI view to its hosting controller


```swift 
func update(component: HomeComponentChild) {
    guard
        let homeChildComponent = component as? HomeComponentChild.Tab3,
        homeChildComponent !== self.component // Always compare is the object is the same, to reduce screen updates
    else {
        return
    }
    
    self.component = homeChildComponent.component // Save new component
    controller.rootView = PokemonView(component: homeChildComponent.component).embedded(in: controller) // Update the View
    
    bottomSheetState.recreate(homeChildComponent.component.bottomSheetControl.sheetState) // Recreate BottomSheet with new `Control`
}
```


## Bottom Sheet
To present a bottom sheet you should use the `presentAsBottomSheet(_ controller:)` method of `BottomSheetPresentable`. Since the lib we use for bottom sheets should be called from viewController, all presenting logic should be moved to hosting controller of SUI view. Since children of `StackNavigationController` and `StackView` are `UIHostingController`-s, the logic of presenting should be placed there. `StackNavigationController`, `HomeTabBarController` and `HostingController` are `BottomSheetPresentable` by default.  The bottom sheet content will be the `HostingController` with its specific SUI view. Don't forget to put `control.dismiss()` to the `deinit` of hosting controller. `BottomSheetPresentable` supports the presenting of non dismissible bottom sheet via overriding `canBottomSheetBeDismissed` in the  parent controller. 

In the case if the logic of bottom sheet presenting could not be moved to hosting controller for some reason, you can use next code in SUI view to get hosting controller from view:
```swift
// The way to get hosting controller of the view
@EnvironmentObject private var hostWrapper: HostWrapper<Self>

...

hostWrapper.controller? ...
```

## Dialogs
To present the dialog you should SUI `.alert` method and pass all needed data from dialogControl of specific component from shared code.

```swift
@ObservedObject private var dialog: ObservableState<ChildOverlay<AnyObject, PokemonVoteDialogComponent>>
@State private var isDialogPresented = false

var body: some View {
    ...
    .alert(
        getAlertTitle(),
        isPresented: $isDialogPresented,
        actions: { DialogButtons(dialogComponent: dialog.value.overlay?.instance) },
        message: { Text(getAlertMessage()) }
    )
    .onChange(of: isDialogPresented) { [oldValue = isDialogPresented] newValue in
        if oldValue == true && newValue == false {
            dialog.value.overlay?.instance?.dismiss()
        }
    }
}
```

## Wrappers
The variables used to subscribe to Kotlin CFlow updates are: NullableObservableState, ObservableState, UnsafeObservableState and CFlowWrapper. Example usage:

```swift
@ObservedObject private var overlay: ObservableState<ChildOverlay<AnyObject, PokemonVotesComponent>>

init(control: BottomSheetControl<PokemonVotesComponentConfig, PokemonVotesComponent>) {
    self.overlay = ObservableState(control.sheetOverlay)
}
``` 

## BackDispatcherService
Call ```BackDispatcherService.shared.backDispatcher.back()``` to jump back to the previous screen in the shared code

## ViewModifiers:

### LoadableWithError
Used for LoadableState variables, defines the loadable state - empty data, load, error. Adds the ability to pull-to-refresh and repeat the request by action. 

```swift
var body: some View {
    PokemonsContentView(
        pokemons: (pokemonsState.value.data as? [Pokemon]) ?? [],
        types: (types.value as? [PokemonType]) ?? [],
        selectedTypeId: selectedTypeId.value,
        onPokemonClick: { id in component.onPokemonClick(pokemonId: id) },
        onTypeClick: { id in component.onTypeClick(typeId: id) }
    )
    .loadableWithError(
        loadableState: pokemonsState,
        onRefresh: { component.onRefresh() },
        onRetryClick: { component.onRetryClick() }
    )
}
```

### ScrollOnOverflow
Used to work with BottomSheet that contains a ScrollView. If your BottomSheet should be dynamic height and contain Scrollable Content, this modifier will calculate the height of the resulting content and wrap it in ScrollView if necessary.

``swift
VStack(spacing: .zero) {
    ForEach(votes.value.votes, id: \.self) { vote in
        HStack(spacing: .zero) {
            Text(vote.pokemonName)
            Spacer()
            
            Text(getVoteText(isPositive: vote.isPositive?.boolValue ?? true))
                .foregroundColor(vote.isPositive?.boolValue ?? true ? .green : .red)
        }
        .padding(16)
    }
}
.scrollOnOverflow(verticalInsets: 48) // You have to calculate all another views height, to define minimal height
```

### NavigateBackOnSwipe
An analogue of the system gesture for back-swipe gesture

```swift
var body: some View {
    Group {
        ...
    }
    .contentShape(Rectangle()) // To enable gesture to empty spaces of view
    .navigateBackOnSwipe()
}
```

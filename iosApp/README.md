# KMM iOS MobileUp Template

## Project structure
```
.
├── Source
│   ├── Application
│   │   ├── Application.swift - Application class where we initialize Shared SDK.
│   │   ├── Global.swift - Global imports of shared module and Utils library.
│   │   └── RootHolder.swift - Class for life circle management and configuration. 
│   ├── Base
│   │   ├── Foundation
│   │   │   └── State - The states to connect Kotlin CStateFlow with Swift ObservableObject.
│   │   │       ├── NullableObservableState.swift - State to handle optional values.
│   │   │       ├── ObservableState.swift - State to handle non optional values.
│   │   │       └── UnsafeObservableState.swift - State to handle unsafe values.
│   │   ├── SUI
│   │   │   ├── Controllers
│   │   │   │   ├── HostingController.swift - Base controller to host SUI view.
│   │   │   │   └── NavigatableHostingController.swift - Base controller to host SUI view to place in StackView.
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
│   │   │       └── Refreshable.swift - Modifier for adding refreshable logic to view.
│   │   └── UIKit
│   ├── Resources
│   │   ├── Assets
│   │   │   ├── Assets.xcassets - Assets imported from Figma.
│   │   │   └── Images.xcassets - Assets added from Figma via manual way.
│   │   └── R.generated - Generated file to use assets.
│   ├── Preview Content
│   │   └── PreviewAssets.xcassets - Preview assets.
│   ├── Protocols
│   │   ├── BottomSheetPresentable.swift - Protocol for BottomSheet presenting.
│   │   └── Navigatable.swift - Protocol for navigation bar configuration.
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
│           └── RootView.swift - The root view of the application.
├── rswift - Executable file for RSwift.
├── swiftlint.yml - SwiftLint settings file.
└── iosApp.xcodeproj
```

## Technology stack
SwiftUI, UIKit, BottomSheet, Kingfisher, Utils, R, iOS 15.1+

## Инициализация
Стартовой точкой входа является UIKit - flow, мы используем App и SceneDelegate. В SceneDelegate проставляем рутовым контроллер RootController. В базовую реализацию мы сразу добавили SplashScreen, находящийся на отдельном контроллере, после анимации которого происходит updateWindow с проставлением RootController и настройкой transition. В RootController необходимо создать компонент RootComponent, для этого используется класс RootHolder, обращающийся к shared core коду. 

## Важные сущности:

### Таббар



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
            ForEach(childStack.value.items, id: \.instance) { child in
                switch child.instance {
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
        .transition(.opacity)
        .animation(.easeInOut, value: component.childStack.value.items)
        .ignoresSafeArea()
    }
}
```

## Navigation
Use `StackNavigationController` as a child viewController of tabBar (to have an ability to hide tabBar when push) and `StackView` as SUI representation of `StackNavigationController` in any other cases.
```swift
final class PokemonController: StackNavigationController<PokemonsComponentChild> {    
    private var component: PokemonsComponent
    
    init(component: PokemonsComponent) {
        self.component = component
        
        super.init(
            stackState: ObservableState(component.childStack)
        ) { child in
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
    }
}

struct FlowTwoView: View {
    let component: Flow2Component
    
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, Flow2ComponentChild>>
    
    init(component: Flow2Component) {
        self.component = component
        self.childStack = ObservableState(component.childStack)
    }
    
    var body: some View {
        StackView(
            stackState: childStack,
            childScreen: { child in
                switch child {
                case let screen1A as Flow2ComponentChild.Screen2A:
                    return ScreenTwoAController(component: screen1A.component)
                case let screen1B as Flow2ComponentChild.Screen2B:
                    return ScreenTwoBController(component: screen1B.component)
                case let screen1C as Flow2ComponentChild.Screen2C:
                    return ScreenTwoCController(component: screen1C.component)
                default:
                    return nil
                }
            }
        )
    }
}
```

## TabBar
To create a tabBar you should copy `HomeTabBarView` and `HomeTabBarCoordinator` and fix it to use your components and represent your screens. Actually, all you have to do is to change types, all other specific logic should not be changed.

\* Mention the `addViewController` and `update` methods of `HomeTabBarView` and `HomeTabBarCoordinator`. The mechanism of replacing/updating of child components is needed since the tabItem is the part of the viewController, we need all view controllers as tabBar children before all tabBar components are inited and placed to the stack, and the recreating of viewControllers is not good idea.

\*\* Pay attention, that in `update` method of TabOneController we use `embedded(in:)` modifier to keep access of SUI view to its hosting controller

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

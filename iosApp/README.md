# KMM iOS MobileUp Template

## Project structure
TBD

## Technology stack
SwiftUI, UIKit, BottomSheet, Kingfisher, Utils, R, iOS 15.1+

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
To present a bottom sheet you should use the `presentAsBottomSheet(_ controller:)` method or its modification. Since the lib we use for bottom sheets should be called from viewController, all presenting logic should be moved to hosting controller of SUI view. Since children of `StackNavigationController` and `StackView` are `UIHostingController`-s, the logic of presenting should be placed there. The bottom sheet content will be the `HostingController` with its specific SUI view. Don't forget to put `control.dismiss()` to the `deinit` of hosting controller.

In the case if the logic of bottom sheet presenting could not be moved to hosting controller for some reason, you can use next code in SUI view to get hosting controller from view:
```swift
// The way to get hosting controller of the view
@EnvironmentObject private var hostWrapper: HostWrapper

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

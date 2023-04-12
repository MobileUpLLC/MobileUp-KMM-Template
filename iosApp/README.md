# KMM iOS MobileUp Template

## Project structure
TBD

## Technology stack
SwiftUI, UIKit, BottomSheet, Kingfisher, Utils, R, iOS 15.1+

## RootView
`RootView` is the SUI view which represents all components in root stack dynamically base on stack changes. The stack components are represented via SUI views, one for specific flow (straight navigation usually), some kind of container for stack component child. To make it work just change the types of views (SUI views) and components (created on android side). 

## Navigation
Use `StackNavigationController` as a child viewController of tabBar (to have an ability to hide tabBar when push) and `StackView` as SUI representation of `StackNavigationController` in any other cases.

## TabBar
To create a tabBar you should copy `HomeTabBar` and `HomeTabBarCoordinator` and fix it to use your components and represent your screens. Actually, all you have to do is to change types, all other specific logic should not be changed.

\* Mention the `addViewController` and `update` methods of `HomeTabBar` and `HomeTabBarCoordinator`. The mechanism of replacing/updating of child components is needed since the tabItem is the part of the viewController, we need all view controllers as tabBar children before all tabBar components are inited and placed to the stack, and the recreating of viewControllers is not good idea.

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
TBD

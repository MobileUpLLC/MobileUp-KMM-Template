package ru.mobileup.kmm_template.features.home

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.home.tab1.FakeTab1Component

class FakeHomeComponent : HomeComponent {
    override val childStack = MutableStateFlow(
        createFakeChildStack(
            HomeComponent.Child.Tab1(FakeTab1Component()) as HomeComponent.Child
        )
    )

    override val selectedTab: StateFlow<HomeTab> = MutableStateFlow(HomeTab.Tab1)

    override fun onTabSelected(tab: HomeTab) = Unit
}
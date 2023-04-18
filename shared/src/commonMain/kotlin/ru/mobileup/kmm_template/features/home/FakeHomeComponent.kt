package ru.mobileup.kmm_template.features.home

import ru.mobileup.kmm_template.core.utils.createFakeChildStack
import ru.mobileup.kmm_template.features.home.tab1.FakeTab1Component

class FakeHomeComponent : HomeComponent {
    override val childStack = createFakeChildStack(
        HomeComponent.Child.Tab1(FakeTab1Component()) as HomeComponent.Child
    )

    override fun onTabSelected(tab: HomeTab) = Unit
}
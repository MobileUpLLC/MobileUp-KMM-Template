//
//  RootComponentChild+TabComponent.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

extension RootComponentChild {
    /// Извлекает компонент табов из текущего экземпляра `RootComponentChild`
    /// для создания представления табов.
    ///
    /// Возвращает `MainComponent` только если текущий компонент имеет тип `.main`.
    /// В остальных случаях, таких как другие типы навигации или экранов, возвращается `nil`,
    /// так как не все экземпляры `RootComponentChild` содержат компонент табов.
    ///
    /// - Returns: `MainComponent` для табов, если компонент является `.main`, иначе `nil`.
    func getTabComponent() -> HomeComponent? {
        if case .home(let value) = onEnum(of: self) {
            return value.component
        } else {
            return nil
        }
    }
}

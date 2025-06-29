//
//  AppearanceService.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 22.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import UIKit

enum AppearanceService {
    static let foregroundColor: UIColor = .black
    static let backgroundColor: UIColor = .white
    static let font: UIFont? = .systemFont(ofSize: 32, weight: .medium)
    static let backButton: UIImage = .init(systemName: "arrow.left")!
    
    static let selectedTab: UIColor = .white
    static let normalTab: UIColor = .white.withAlphaComponent(0.5)
    static let backgroundTab: UIColor = .systemBlue
    static let fontTab: UIFont = .systemFont(ofSize: 17, weight: .medium)
    
    static func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        if let font {
            appearance.largeTitleTextAttributes = [
                .foregroundColor: foregroundColor,
                .font: font
            ]
        }
        appearance.shadowColor = .clear
        
        // Устанавливаем кастомную кнопку "Назад"
        appearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)
        
        // Ставим цвет текста кнопки "Назад"
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: foregroundColor.withAlphaComponent(0) // Скрываем
        ]
        appearance.backButtonAppearance = backButtonAppearance
        
        // Стили для кнопок навигации
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: foregroundColor]
        appearance.buttonAppearance = buttonAppearance
        
        // Применяем стили к навигационной панели
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Ставим цвет иконки кнопки "Назад"
        UIBarButtonItem.appearance().tintColor = foregroundColor
    }
    
    static func setupTabBar() {
        let appearance = UITabBarAppearance()
        
        // Цвет фона таббара
        appearance.backgroundColor = backgroundTab
        
        // Цвет текста и иконки в неактивных табах
        appearance.stackedLayoutAppearance.normal.iconColor = normalTab
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: fontTab,
            .foregroundColor: normalTab
        ]
        
        // Цвет текста и иконки в активном табе
        appearance.stackedLayoutAppearance.selected.iconColor = selectedTab
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: fontTab,
            .foregroundColor: selectedTab
        ]
        
        // Применяем стили
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

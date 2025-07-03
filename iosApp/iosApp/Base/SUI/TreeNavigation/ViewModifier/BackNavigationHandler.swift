//
//  BackNavigationHandler.swift
//  iosApp
//
//  Created by Denis Dmitriev on 25.05.2025.
//

import SwiftUI

/// Модификатор для обработки пользовательского "назад" в навигации KMM
struct BackNavigationHandler: ViewModifier {
    @EnvironmentObject var navigationModel: NavigationModel
    
    func body(content: Content) -> some View {
        content
            .onChange(of: navigationModel.path) { newPath in
                if navigationModel.previousPath.count > newPath.count {
                    BackDispatcherService.shared.backDispatcher.back()
                }
                navigationModel.previousPath = newPath
            }
    }
}

extension View {
    /// Применяет обработчик пользовательского "назад" для навигации KMM
    ///
    /// - Attention: Вешается всего раз в стеке навигации, иначе будет коллизия.
    func backNavigationHandler() -> some View {
        modifier(BackNavigationHandler())
    }
}

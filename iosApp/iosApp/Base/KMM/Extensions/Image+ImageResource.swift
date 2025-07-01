//
//  Image+ImageResource.swift
//  iosApp
//
//  Created by Denis Dmitriev on 20.05.2025.
//

import SwiftUI

extension Image {
    /// Инициализирует `SwiftUI.Image` из `ImageResource` KMM.
    /// - Parameter kmm: Ресурс изображения из KMM. Если `nil`, создается пустое изображение.
    init?(kmm: shared.ImageResource?) {
        if let uiImage = kmm?.toUIImage() {
            self.init(uiImage: uiImage)
        } else {
            return nil
        }
    }
}

//
//  NavigateBackOnSwipe.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

extension View {
    func navigateBackOnSwipe(isEnabled: Bool = true) -> some View {
        Group {
            if isEnabled {
                self
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.predictedEndTranslation.width > 100 {
                                    BackDispatcherService.shared.backDispatcher.back()
                                }
                            }
                    )
            } else {
                self
            }
        }
    }
}

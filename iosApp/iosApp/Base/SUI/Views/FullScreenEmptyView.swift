//
//  FullScreenEmptyView.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FullScreenEmptyView: View {
    private let emptyStateDescription: String
    private let verticalInsets: CGFloat
    private let isWithBackSwipe: Bool
    private let isRefreshable: Bool
    
    init(
        emptyStateDescription: String,
        verticalInsets: CGFloat,
        isWithBackSwipe: Bool = false,
        isRefreshable: Bool = false
    ) {
        self.emptyStateDescription = emptyStateDescription
        self.verticalInsets = verticalInsets
        self.isWithBackSwipe = isWithBackSwipe
        self.isRefreshable = isRefreshable
    }
    
    var body: some View {
        Group {
            if isRefreshable {
                ScrollView(showsIndicators: false) {
                    HStack(spacing: .zero) {
                        Spacer(minLength: .zero)
                        
                        Text(emptyStateDescription)
                            .font(.body)
                            .padding(.top, getTopPadding())
                        
                        Spacer(minLength: .zero)
                    }
                    .padding(.horizontal, 16)
                }
            } else {
                VStack {
                    Spacer()
                    
                    Text(emptyStateDescription)
                        .font(.body)
                    
                    Spacer()
                }
            }
        }
        .contentShape(Rectangle())
//        .navigateBackOnSwipe(isEnabled: isWithBackSwipe)
    }
    
    private func getTopPadding() -> CGFloat {
        let height = UIScreen.main.bounds.height
        - (UIApplication.getSafeAreaInsets().top + UIApplication.getSafeAreaInsets().bottom)
        - verticalInsets
        
        return height / 2 - 12
    }
}

struct FullScreenEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenEmptyView(emptyStateDescription: .empty, verticalInsets: .zero)
    }
}

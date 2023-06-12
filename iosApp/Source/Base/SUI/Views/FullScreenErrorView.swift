//
//  FullScreenErrorView.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct FullScreenErrorView: View {
    private let error: String
    private let isWithBackSwipe: Bool
    private let onRetryClick: Closure.Void?
    
    init(error: String, isWithBackSwipe: Bool = false, onRetryClick: Closure.Void?) {
        self.error = error
        self.isWithBackSwipe = isWithBackSwipe
        self.onRetryClick = onRetryClick
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 56, height: 56)
            
            Text("Произошла ошибка")
                .font(.title)
                .padding(.top, 30)
                .padding(.bottom, 8)
            
            Text(error)
                .font(.subheadline)
            
            Spacer(minLength: 32)
            
            if let onRetryClick {
                Button {
                    onRetryClick()
                } label: {
                    Text("Попробовать еще раз")
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(.white)
        .navigateBackOnSwipe(isEnabled: isWithBackSwipe)
    }
}

struct FullScreenErrorView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenErrorView(error: .empty, onRetryClick: {})
    }
}

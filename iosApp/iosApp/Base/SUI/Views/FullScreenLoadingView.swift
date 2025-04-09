//
//  FullScreenLoading.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 01.06.2023.
//  Copyright © 2023 Mobile Up. All rights reserved.
//

import SwiftUI

struct FullScreenLoadingView: View {
    private let isWithBackSwipe: Bool
    
    init(isWithBackSwipe: Bool = false) {
        self.isWithBackSwipe = isWithBackSwipe
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                
                ProgressView()
                    .scaleEffect(1.3)
                
                Spacer()
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
//        .navigateBackOnSwipe(isEnabled: isWithBackSwipe)
    }
}

struct FullScreenLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenLoadingView()
    }
}

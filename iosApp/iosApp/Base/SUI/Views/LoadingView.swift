//
//  LoadingView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 17.06.2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var angle: Angle = .zero
    
    private let lineWidth: CGFloat = 4
    
    var body: some View {
        ProgressView()
            .scaleEffect(1.3)
    }
}

#Preview {
    LoadingView()
}

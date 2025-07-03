//
//  VotesButtonView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

struct VotesButtonView: View {
    let onAction: () -> Void
    
    var body: some View {
        Button {
            onAction()
        } label: {
            Image(systemName: "book.circle.fill")
                .font(.system(size: 50))
        }
    }
}

#Preview {
    VotesButtonView(onAction: {})
}

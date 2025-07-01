//
//  SimpleTitleView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 16.05.2025.
//

import SwiftUI

struct SimpleTitleView: View {
    let title: String
    let action: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title.weight(.bold))
            if let action {
                Button(action: action) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
            }
        }
    }
}

#Preview {
    SimpleTitleView(title: "Title", action: {})
}

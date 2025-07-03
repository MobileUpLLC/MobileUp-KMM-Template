//
//  PokemonPropertyView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 10.04.2025.
//

import SwiftUI

struct PokemonPropertyView: View {
    let property: String
    let icon: Image
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Label {
                Text(property)
                    .font(.system(size: 12, weight: .medium))
            } icon: {
                icon
            }
            .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
        }
    }
}

#Preview {
    PokemonPropertyView(property: "Height", icon: Image(systemName: "arrow.up.and.down.square"), value: "168")
}

//
//  PropertyView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 15.05.2025.
//

import SwiftUI

struct PropertyView: View {
    let property: String
    let value: String
    
    var body: some View {
        HStack {
            Text(property)
                .font(.headline)
            Text(value)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PropertyView(property: "Type", value: "Value")
}

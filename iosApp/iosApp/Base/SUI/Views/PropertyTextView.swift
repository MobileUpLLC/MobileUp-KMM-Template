//
//  PropertyTextView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 20.05.2025.
//

import SwiftUI

struct PropertyTextView: View {
    let header: String?
    let property: String
    
    let action: (() -> Void)?
    
    init(header: String? = nil, property: String, action: (() -> Void)? = nil) {
        self.header = header
        self.property = property
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let header {
                Text(header)
                    .font(.title2.bold())
            }
            HStack(spacing: 10) {
                Text(property)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3.bold())
                
                if let action {
                    Button(action: action) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                }
            }
        }
        .padding(.vertical, 5.5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PropertyTextView(header: "Title", property: "Property : Value", action: {})
}

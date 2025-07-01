//
//  TextDescriptionView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 02.06.2025.
//

import SwiftUI

struct TextDescriptionView<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content
    
    init(header: @escaping () -> Header, content: @escaping () -> Content) {
        self.header = header
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header()
                .font(.title2.bold())
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TextDescriptionView {
        Text("Title")
    } content: {
        Text("Content")
    }
}

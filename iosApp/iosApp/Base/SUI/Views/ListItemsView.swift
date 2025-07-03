//
//  ListItemsView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 20.05.2025.
//

import SwiftUI

struct ListItemsView<Data: Collection, Content: View, Header: View>: View where Data.Element: Hashable {
    let items: Data
    let header: () -> Header
    let content: (Data.Element) -> Content
    
    var body: some View {
        VStack(spacing: 10) {
            header()
            FlexibleView(data: items, spacing: 8, alignment: .leading, content: content)
        }
    }
}

#Preview {
    ListItemsView(
        items: ["🐰", "🐨", "🐶"],
        header: {
            Text("Animal List")
        },
        content: { item in
            Text(item)
        }
    )
}

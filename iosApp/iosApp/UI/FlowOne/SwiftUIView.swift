//
//  SwiftUIView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

enum Fruct: CaseIterable, Hashable {
    case apple
    case banana
    
    var title: String {
        switch self {
        case .apple:
            return "Apple"
        case .banana:
            return "Banana"
        }
    }
    
    var emoji: String {
        switch self {
        case .apple:
            return "🍎"
        case .banana:
            return "🍌"
        }
    }
}

enum Shop: CaseIterable, Hashable {
    case catalog
    case basket
    
    var title: String {
        switch self {
        case .catalog:
            return "Catalog"
        case .basket:
            return "Basket"
        }
    }
    
    var emoji: String {
        switch self {
        case .catalog:
            return "🛒"
        case .basket:
            return "🛍️"
        }
    }
}

struct ShopView: View {
    @State private var path = NavigationPath()
    @State private var pathProxy: [AnyHashable] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            Button(action: {
                pathProxy.append(Shop.catalog)
            }, label: {
                Text("🏪")
            })
            .font(.largeTitle)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("🛒") {
                        pathProxy.append(Shop.basket)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationDestination(for: Shop.self, destination: destination(for:))
            .navigationTitle("Shop")
        }
        .onChange(of: pathProxy) { newValue in
            if newValue.count < pathProxy.count {
                path.removeLast()
            } else {
                if let shopStep = newValue.last as? Shop {
                    path.append(shopStep)
                } else if let fructStep = newValue.last as? Fruct {
                    path.append(fructStep)
                }
            }
            // TODO: Нужно эту логику перенести в RootView
        }
    }
    
    @ViewBuilder
    func destination(for step: Shop) -> some View {
        switch step {
        case .catalog:
            CatalogView(path: $pathProxy)
        case .basket:
            Text(step.emoji)
                .font(.largeTitle)
                .navigationTitle(step.title)
        }
    }
}

struct CatalogView: View {
    @Binding var path: [AnyHashable]
    
    var body: some View {
        List {
            ForEach(Fruct.allCases, id: \.self) { fruct in
                Button(action: {
                    path.append(fruct)
                }) {
                    Text(fruct.emoji)
                }
            }
        }
        .navigationTitle("Catalog")
        .navigationDestination(for: Fruct.self, destination: destination(for:))
    }
    
    @ViewBuilder
    func destination(for fruct: Fruct) -> some View {
        Text(fruct.emoji)
            .font(.largeTitle)
            .navigationTitle(fruct.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("🛒") {
                        path.append(Shop.basket)
                    }
                    .buttonStyle(.bordered)
                }
            }
    }
}

#Preview("Shop") {
    ShopView()
}

#Preview("Catalog") {
    CatalogView(path: .constant([]))
}

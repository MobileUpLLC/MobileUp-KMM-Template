//
//  ScrollOnOverflow.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

extension View {
    func scrollOnOverflow(verticalInsets: CGFloat = .zero) -> some View {
        modifier(OverflowContentViewModifier(verticalInsets: verticalInsets))
    }
    
    fileprivate func wrappedInScrollView(isScrollable: Bool) -> some View {
        modifier(ScrollableModifier(isScrollable: isScrollable))
    }
}

private struct OverflowContentViewModifier: ViewModifier {
    let verticalInsets: CGFloat
    
    @State private var isScrollable = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.onAppear {
                        let allInsets = verticalInsets + 16 + (UIApplication.getSafeAreaInsets().top + UIApplication.getSafeAreaInsets().bottom)
                        isScrollable = contentGeometry.size.height > UIScreen.main.bounds.height - allInsets
                    }
                }
            )
            .wrappedInScrollView(isScrollable: isScrollable)
    }
}

private struct ScrollableModifier: ViewModifier {
    let isScrollable: Bool
    
    func body(content: Content) -> some View {
        if isScrollable {
            ScrollView(showsIndicators: false) {
                content
            }
        } else {
            content
        }
    }
}

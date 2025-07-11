//
//  View+ReadSize.swift
//  iosApp
//
//  Created by Denis Dmitriev on 16.05.2025.
//
// Original article here: https://fivestars.blog/articles/swiftui-share-layout-information/

import SwiftUI

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

private struct SizePreferenceKey: @preconcurrency PreferenceKey {
  @MainActor static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

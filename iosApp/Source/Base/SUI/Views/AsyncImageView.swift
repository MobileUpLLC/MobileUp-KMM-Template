//
//  AsyncImageView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 22.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {
    let imageLink: String?
    var placeholder: Image?
    var placeholderColor: Color?
    var onDownload: Closure.Void?
    
    var body: some View {
        KFImage(URL(string: imageLink ?? .empty))
            .onSuccess { _ in
                onDownload?()
            }
            .placeholder {
                placeholder?
                    .resizable()
            }
            .resizable()
            .background(placeholderColor ?? .clear)
          // onAppear needs to be called for image to render properly in iOS 16 List
          // https://github.com/onevcat/Kingfisher/issues/1988
            .onAppear()
    }
}

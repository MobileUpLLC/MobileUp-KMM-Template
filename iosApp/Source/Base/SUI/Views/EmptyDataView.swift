//
//  EmptyDataView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 11.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct EmptyDataViewItem {
    var image: Image? = Image(systemName: "bolt.ring.closed")
    var title: String = .empty
}

struct EmptyDataView: View {
    let item: EmptyDataViewItem
    
    var body: some View {
        VStack(spacing: 16) {
            item.image
            Text(item.title)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct EmptyDataView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDataView(item: EmptyDataViewItem())
    }
}

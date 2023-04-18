//
//  BaseView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//
//  NavigationBarInfoView.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

final class NavigationBarInfoView: BaseView {
    private enum Constants {
        static let logoImageHeight: CGFloat = 24
        static let titleIconSpacing: CGFloat = 4
        static let iconWithTitleSize: CGFloat = 16
    }
    
    // Change color and font for specific project style
    static let titleColor: UIColor = .black
    static let titleFont: UIFont = .systemFont(ofSize: 15)
    
    private let item: NavigationBarInfoItem
    
    required init(item: NavigationBarInfoItem) {
        self.item = item
        super.init(frame: .zero)
        
        setup()
    }
    
    private func setup() {
        switch item.itemType {
        case .title(let title):
            setupWithTitle(title)
        case .titleWithIcon(let item):
            setupTitleWithIcon(item: item)
        }
    }
    
    private func setupTitleWithIcon(item: IconTitleItem) {
        let label = UILabel()
        label.text = item.title
        label.textColor = Self.titleColor
        label.font = Self.titleFont
        
        let imageView = UIImageView(image: item.icon)
        imageView.contentMode = .scaleAspectFit
        imageView.layoutSize(height:  Constants.iconWithTitleSize, width: Constants.iconWithTitleSize)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.titleIconSpacing
        
        layoutCenter(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    private func setupWithTitle(_ title: String) {
        let label = UILabel()
        label.text = title
        label.textColor = Self.titleColor
        label.font = Self.titleFont
        
        layoutCenter(label)
    }
}

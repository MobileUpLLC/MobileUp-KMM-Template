//
//  Navigatable.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 31.03.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import UIKit

struct IconTitleItem {
    let icon: UIImage
    let title: String
}

struct NavigationBarActionItem {
    enum ItemType {
        static let dismissItem = ItemType.icon(UIImage(systemName: "xmark"))
        static let popItem = ItemType.icon(UIImage(systemName: "chevron.left"))
        
        case title(String)
        case icon(UIImage?)
    }
    
    static var empty: Self {
        NavigationBarActionItem(item: .title(.empty), action: nil)
    }
    
    let item: ItemType
    let action: Closure.Void?
    
    init(item: ItemType, action: Closure.Void? = nil) {
        self.item = item
        self.action = action
    }
}

struct NavigationBarInfoItem {
    enum ItemType {
        case title(String)
        case titleWithIcon(IconTitleItem)
    }
    
    static var empty: Self {
        NavigationBarInfoItem(item: .title(.empty))
    }
    
    let itemType: ItemType
    
    init(item: ItemType) {
        self.itemType = item
    }
}

struct NavigationBarModel {
    static var `default`: Self {
        NavigationBarModel(infoToolbarItem: .empty)
    }
    
    var infoToolbarItem: NavigationBarInfoItem
    var leftToolbarItem: NavigationBarActionItem?
    var rightToolbarItems: [NavigationBarActionItem]?
    let isLargeTitle: Bool
    
    init(
        infoToolbarItem: NavigationBarInfoItem,
        leftToolbarItem: NavigationBarActionItem? = nil,
        rightToolbarItems: [NavigationBarActionItem]? = nil,
        isLargeTitle: Bool = false
    ) {
        self.leftToolbarItem = leftToolbarItem
        self.rightToolbarItems = rightToolbarItems
        self.infoToolbarItem = infoToolbarItem
        self.isLargeTitle = isLargeTitle
    }
}

protocol Navigatable {
    var navigationBarModel: NavigationBarModel { get }
    var isNavigationBarHidden: Bool { get }
    
    func setupNavBar()
}

extension Navigatable where Self: UIViewController {
    private var avatarSize: CGFloat { 28 }
    
    func setupNavBar() {
        setupTitleDisplayMode()
        setupInfoToolbarItem()
        setupLeftToolbarItem()
        setupRightToolbarItems()
    }
    
    func setupNavigationBarVisibility() {
        navigationController?.navigationBar.isHidden = isNavigationBarHidden
    }
    
    private func setupTitleDisplayMode() {
        // Change color to specific project style
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = navigationBarModel.isLargeTitle ? .always : .never
    }
    
    private func setupInfoToolbarItem() {
        if navigationBarModel.isLargeTitle {
            setupLargeTitleIfNeeded()
        } else {
            let infoView = NavigationBarInfoView(item: navigationBarModel.infoToolbarItem)
            navigationItem.titleView = infoView
        }
    }
    
    private func setupLeftToolbarItem() {
        navigationItem.backButtonDisplayMode = .minimal
        
        guard let leftItem = navigationBarModel.leftToolbarItem else {
            return
        }
        
        switch leftItem.item {
        case .icon(let icon):
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: icon,
                style: .plain,
                target: self,
                action: #selector(leftToolbarItemDidTap)
            )
        case .title:
            return
        }
    }
    
    private func setupRightToolbarItems() {
        guard let rightItems = navigationBarModel.rightToolbarItems else {
            return
        }
        
        var rightBarItems: [UIBarButtonItem] = []
        
        for index in rightItems.indices {
            switch rightItems[index].item {
            case .icon(let icon):
                let newItem = UIBarButtonItem(
                    image: icon,
                    style: .plain,
                    target: self,
                    action: #selector(rightToolbarItemDidTap)
                )
                
                newItem.tag = index
                rightBarItems.append(newItem)
            case .title:
                return
            }
            
            // needed for correct setup on ios 15
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItems = rightBarItems
            }
        }
    }
    
    private func setupLargeTitleIfNeeded() {
        if case .title(let title) = navigationBarModel.infoToolbarItem.itemType {
            navigationItem.title = title
        } else {
            navigationItem.title = .empty
        }
    }
}

private extension UIViewController {
    @objc func leftToolbarItemDidTap() {
        guard let self = self as? Navigatable else {
            return
        }
        
        self.navigationBarModel.leftToolbarItem?.action?()
    }
    
    @objc func rightToolbarItemDidTap(_ sender: UITabBarItem) {
        guard let self = self as? Navigatable else {
            return
        }
        
        self.navigationBarModel.rightToolbarItems?[sender.tag].action?()
    }
}

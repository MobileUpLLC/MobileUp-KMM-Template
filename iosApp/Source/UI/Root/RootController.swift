//
//  RootController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 05.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Combine

final class RootController: UIViewController {
    @ObservedObject private var childStack: ObservableState<ChildStack<AnyObject, RootComponentChild>>
    
    private let component: RootComponent
    private var rootHolder = RootHolder()
    private var subscriptions: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChilds()
        
        childStack.objectWillChange.sink { [weak self] in
            DispatchQueue.main.async {
                self?.updateChilds()
            }
        }
        .store(in: &subscriptions)
        
        // TODO: iOS добавить отображение ошибок из MessageComponent.
        // На Android они отображаются в виде снекбаров поверх основного содержимого.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootHolder.onViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootHolder.onViewDisappear()
    }
    
    init() {
        self.component = rootHolder.rootComponent
        self.childStack = ObservableState(component.childStack)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateChilds() {
        childStack.value.items.forEach { [weak self] child in
            self?.checkAndUpdate(component: child.instance)
        }
    }
    
    private func checkAndUpdate(component: RootComponentChild?) {
        switch component {
        case let flowOne as RootComponentChild.Flow1:
            if children.contains(where: { $0 is FlowOneController }) == false {
                addChild(controller: FlowOneController(component: flowOne.component))
            }
        case let flowTwo as RootComponentChild.Flow2:
            if children.contains(where: { $0 is FlowTwoController }) == false {
                addChild(controller: FlowTwoController(component: flowTwo.component))
            }
        case let home as RootComponentChild.Home:
            if children.contains(where: { $0 is HomeTabBar }) == false {
                addChild(controller: HomeTabBar(component: home.component))
            }
        default:
            break
        }
        
        // TODO: iOS Delete VC if no component
    }
}

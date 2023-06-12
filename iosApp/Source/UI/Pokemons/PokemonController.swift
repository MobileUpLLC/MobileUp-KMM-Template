//
//  PokemonController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI
import Combine

final class PokemonController: NavigatableHostingController<PokemonView>, HomeTabViewController {
    override var canBottomSheetBeDismissed: Bool { component.bottomSheetControl.hidingSupported  }
    
    var homeTab: HomeTab { .tab3 }
    
    private var component: PokemonsComponent
    private var subscriptions: [AnyCancellable] = []
    
    @ObservedObject private var bottomSheetState: ObservableState<BottomSheetControlState>
    
    init(component: PokemonsComponent) {
        self.component = component
        self.bottomSheetState = ObservableState(component.bottomSheetControl.sheetState)
        
        super.init(rootView: PokemonView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab3_label.desc().localized(),
            image: UIImage(systemName: "3.square"),
            tag: .two
        )
        
        bottomSheetState.objectWillChange.sink { [weak self] in
            let value = self?.bottomSheetState.value ?? .hidden
            
            DispatchQueue.main.async {
                self?.updateBottomSheetState(oldValue: value)
            }
        }
        .store(in: &subscriptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    func update(component: HomeComponentChild) {
        guard
            let homeChildComponent = component as? HomeComponentChild.Tab3,
            homeChildComponent !== self.component
        else {
            return
        }
        
        self.component = homeChildComponent.component
        controller.rootView = PokemonView(component: homeChildComponent.component).embedded(in: controller)
        
        bottomSheetState.recreate(homeChildComponent.component.bottomSheetControl.sheetState)
    }
    
    private func setupButton() {
        let button = UIButton()
        button.layoutSize(height: 50, width: 50)
        
        let image = UIImage(
            systemName: "book.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)
        )
        
        button.addAction(
            UIAction(handler: { [weak self] _ in self?.component.onPokemonVotesButtonClick() }),
            for: .primaryActionTriggered
        )
        
        button.setImage(image, for: .normal)
        view.layoutSubview(button, with: .insets(bottom: 100, right: 24))
    }
    
    private func updateBottomSheetState(oldValue: BottomSheetControlState) {
        switch bottomSheetState.value {
        case .expanded, .halfexpanded:
            if [.expanded, .halfexpanded].contains(oldValue) {
                break
            }
            
            presentBottomSheet()
        case .hidden:
            if oldValue == .hidden {
                break
            }
            
            dismiss(animated: true)
        default:
            break
        }
    }
    
    private func presentBottomSheet() {
        let controller = PokemonVotesController(control: component.bottomSheetControl)
        
        presentAsBottomSheet(controller)
    }
}

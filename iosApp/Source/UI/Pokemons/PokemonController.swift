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
    
    @ObservedObject private var dismissableByUser: ObservableState<KotlinBoolean>
    
    override var canBottomSheetBeDismissed: Bool { CFBooleanGetValue(dismissableByUser.value) }
    
    var homeTab: HomeTab { .tab3 }
    
    @ObservedObject private var dialogSlot: ObservableState<ChildSlot<AnyObject, PokemonVotesComponent>>
    
    private var component: PokemonsComponent
    private var subscriptions: [AnyCancellable] = []
    
    init(component: PokemonsComponent) {
        self.component = component
        self.dialogSlot = ObservableState(component.bottomSheetControl.dialogSlot) as! ObservableState<ChildSlot<AnyObject, PokemonVotesComponent>>
        
        self.dismissableByUser = ObservableState(component.bottomSheetControl.dismissableByUser)
        
        super.init(rootView: PokemonView(component: component))
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab3_label.desc().localized(),
            image: UIImage(systemName: "3.square"),
            tag: .two
        )
        
        dialogSlot.objectWillChange.sink { [weak self] in
            let value = self?.dialogSlot.value.child?.instance
            
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
        
        dialogSlot.recreate(homeChildComponent.component.bottomSheetControl.dialogSlot)
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
    
    private func updateBottomSheetState(oldValue: PokemonVotesComponent?) {
        switch dialogSlot.value.child?.instance {
        case nil:
            if oldValue == nil {
                break
            }
            
            dismiss(animated: true)
        default:
            if oldValue != nil {
                break
            }
            
            presentBottomSheet()
        }
    }
    
    private func presentBottomSheet() {
        let controller = PokemonVotesController(control: component.bottomSheetControl)
        
        presentAsBottomSheet(controller)
    }
}

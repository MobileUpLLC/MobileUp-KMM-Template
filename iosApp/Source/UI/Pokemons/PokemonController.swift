//
//  PokemonController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Combine

final class PokemonController: StackNavigationController<PokemonsComponentChild>, HomeTabViewController {
    var homeTab: HomeTab { .tab3 }
    
    private var component: PokemonsComponent
    @ObservedObject private var bottomSheetState: ObservableState<BottomSheetControlState>
    
    private var subscriptions: [AnyCancellable] = []
    
    init(component: PokemonsComponent) {
        self.component = component
        self.bottomSheetState = ObservableState(component.bottomSheetControl.sheetState)
        
        super.init(
            stackState: ObservableState(component.childStack)
        ) { child in
            switch child {
            case let pokemonsList as PokemonsComponentChildList:
                return PokemonListController(component: pokemonsList.component)
            case let pokemonsDetails as PokemonsComponentChildDetails:
                let controller = PokemonDetailsController(component: pokemonsDetails.component)
                controller.hidesBottomBarWhenPushed = true
                
                return controller
            default:
                return nil
            }
        }
        
        bottomSheetState.objectWillChange.sink { [weak self] in
            let value = self?.bottomSheetState.value ?? .hidden
            
            DispatchQueue.main.async {
                self?.updateBottomSheetState(oldValue: value)
            }
        }
        .store(in: &subscriptions)
        
        tabBarItem = UITabBarItem(
            title: MR.strings().home_tab3_label.desc().localized(),
            image: UIImage(systemName: "3.square"),
            tag: .two
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    func update(component: HomeComponentChild) {
        guard let component = component as? HomeComponentChild.Tab3 else {
            return
        }
        
        self.component = component.component
        
        bottomSheetState.recreate(component.component.bottomSheetControl.sheetState)
        update(stack: component.component.childStack)
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
            break
        default:
            break
        }
    }
    
    private func presentBottomSheet() {
        presentAsBottomSheet(PokemonVotesController(control: component.bottomSheetControl))
    }
}

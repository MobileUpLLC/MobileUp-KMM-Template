//
//  PokemonsController.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 03.04.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import BottomSheet
import Combine

final class PokemonsController: StackNavigationController<PokemonsComponentChild>, HomeTabViewController {
    var homeTab: HomeTab { .tab3 }
    
    private let component: PokemonsComponent
    @ObservedObject private var bottomSheetState: ObservableState<BottomSheetControlState>
    
    private weak var bottomSheetController: UIViewController?
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
            DispatchQueue.main.async {
                self?.updateBottomSheetState()
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
        
        update(stack: component.component.childStack)
    }
    
    private func setupButton() {
        let button = UIButton()
        button.layoutSize(height: 50, width: 50)
        
        let image = UIImage(
            systemName: "plus.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)
        )
        
        button.addAction(
            UIAction(handler: { [weak self] _ in self?.component.onPokemonVotesButtonClick() }),
            for: .primaryActionTriggered
        )
        
        button.setImage(image, for: .normal)
        view.layoutSubview(button, with: .insets(bottom: 100, right: 24))
    }
    
    func updateBottomSheetState() {
        switch bottomSheetState.value {
        case .expanded, .halfexpanded:
            presentBottomSheet()
        case .hidden:
            break
//            bottomSheetController?.dismiss(animated: true)
        default:
            break
        }
    }
    
    private func presentBottomSheet() {
        let viewControllerToPresent = PokemonVotesController(control: component.bottomSheetControl)
        bottomSheetController = viewControllerToPresent
        
        presentBottomSheet(
            viewController: viewControllerToPresent,
            configuration: BottomSheetConfiguration(
                cornerRadius: 10,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }
}

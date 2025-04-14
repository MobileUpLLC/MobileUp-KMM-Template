//
//  PokemonView.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct PokemonView: View, TreeNavigation {
    @StateObject var navigationModel = TreeNavigationModel()
    @StateObject @KotlinStateFlow var childStack: ChildStack<AnyObject, PokemonsComponentChild>
    @StateObject @KotlinStateFlow private var dialogSlot: ChildSlot<AnyObject, PokemonVotesComponent>
    
    private let component: PokemonsComponent
    
    @State private var isPresented: Bool = false
    
    init(component: PokemonsComponent) {
        self.component = component
        _childStack = .init(component.childStack)
        _dialogSlot = .init(component.bottomSheetControl.dialogSlot)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            rootView
                .treeNavigation(childStack: _childStack.wrappedValue, navigationModel: navigationModel, destination: destination(for:))
                .navigationTitle(MR.strings().pokemons_title.desc().localized())
        }
        .setRootTreeNavigation(childStack: _childStack.wrappedValue, navigationModel: navigationModel)
        .overlay(alignment: .bottomTrailing) {
            VotesButtonView(onAction: component.onPokemonVotesButtonClick)
                .padding()
        }
        .bottomSheet(childSlot: dialogSlot, dialogControl: component.bottomSheetControl) {
            PokemonVotesView(control: component.bottomSheetControl)
        }
    }
    
    @ViewBuilder
    func destination(for item: PokemonsComponentChild) -> some View {
        switch onEnum(of: item) {
        case .list(let child):
            PokemonListView(component: child.component)
        case .details(let child):
            PokemonDetailsView(component: child.component)
        }
    }
}

#Preview {
    PokemonView(component: FakePokemonsComponent())
}

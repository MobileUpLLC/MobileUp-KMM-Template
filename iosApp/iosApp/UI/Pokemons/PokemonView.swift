//
//  PokemonView.swift
//  iosApp
//
//  Created by Чаусов Николай on 08.06.2023.
//  Copyright © 2023 MobileUp. All rights reserved.
//

import SwiftUI

struct PokemonView: View, TreeNavigation {
    @StateObject var navigationModel = RootNavigationModel()
    @ObservedObject var childStack: ObservableState<ChildStack<AnyObject, PokemonsComponentChild>>
    @ObservedObject private var dialogSlot: ObservableState<ChildSlot<AnyObject, PokemonVotesComponent>>
    
    private let component: PokemonsComponent
    
    @State private var isPresented: Bool = false
    
    init(component: PokemonsComponent) {
        self.component = component
        childStack = ObservableState(component.childStack)
        dialogSlot = ObservableState(component.bottomSheetControl.dialogSlot)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            rootView
                .treeNavigation(childStack: childStack, navigationModel: navigationModel, destination: destination(for:))
                .navigationTitle(MR.strings().pokemons_title.desc().localized())
        }
        .setRootTreeNavigation(childStack: childStack, navigationModel: navigationModel)
        .overlay(alignment: .bottomTrailing) {
            VotesButtonView(onAction: component.onPokemonVotesButtonClick)
                .padding()
        }
        .bottomSheet(childSlot: dialogSlot.value, dialogControl: component.bottomSheetControl) {
            PokemonVotesView(control: component.bottomSheetControl)
        }
    }
    
    @ViewBuilder
    func destination(for item: PokemonsComponentChild) -> some View {
        switch item {
        case let pokemonsList as PokemonsComponentChild.List:
            PokemonListView(component: pokemonsList.component)
        case let pokemonsDetails as PokemonsComponentChild.Details:
            PokemonDetailsView(component: pokemonsDetails.component)
        default:
            EmptyView()
        }
    }
}

#Preview {
    PokemonView(component: FakePokemonsComponent())
}

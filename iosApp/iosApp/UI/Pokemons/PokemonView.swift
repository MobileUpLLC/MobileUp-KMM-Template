//
//  LibraryView.swift
//  iosApp
//
//  Created by Denis Dmitriev on 05.06.2025.
//

import SwiftUI

struct PokemonView: View {
    let component: PokemonsComponent
    
    @StateObject @KotlinStateFlow private var childStack: ChildStack<AnyObject, PokemonsComponentChild>
    @StateObject private var navigationModel = NavigationModel()
    
    private var rootItem: Router.PokemonsComponent {
        childStack.items
            .compactMap({ $0.instance })
            .map({ onEnum(of: $0) })
            .first ?? .list(.init(component: FakePokemonListComponent()))
    }
    
    init(component: PokemonsComponent) {
        self.component = component
        self._childStack = .init(component.childStack)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            Router.destination(for: .pokemons(rootItem))
                .navigationDestination(for: Router.self, destination: Router.destination(for:))
                .navigationBranch(
                    childStack: _childStack.wrappedValue
                ) { destination in
                    Router.pokemons(onEnum(of: destination))
                }
                .backNavigationHandler()
        }
        .environmentObject(navigationModel)
    }
}

#Preview {
    FlowOneView(component: FakeFlow1Component())
}

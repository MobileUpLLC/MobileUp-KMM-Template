//
//  PokemonType+Swift.swift
//  iosApp
//
//  Created by Vladislav Grokhotov on 20.03.2023.
//  Copyright © 2023 orgName. All rights reserved.
//

extension PokemonType: Identifiable {
    func toSwiftPokemonType() -> SwiftPokemonType {
        return SwiftPokemonType(
            id: self.id as? String ?? .empty,
            name: self.name
        )
    }
}

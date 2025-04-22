//
//  Favourites.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//

import Foundation
import SwiftUI

class Favourites: ObservableObject {
    @Published var savedPokemons: Set<Int> = []
    private let storageKey = "savedPokemonsKey"

    init() {
        load()
    }

    func toggleFavourite(_ pokemon: Pokemon) {
        if savedPokemons.contains(pokemon.id) {
            savedPokemons.remove(pokemon.id)
        } else {
            savedPokemons.insert(pokemon.id)
        }
        save()
    }

    func isFavourite(_ pokemon: Pokemon) -> Bool {
        savedPokemons.contains(pokemon.id)
    }

    private func save() {
        UserDefaults.standard.set(Array(savedPokemons), forKey: storageKey)
    }

    private func load() {
        if let saved = UserDefaults.standard.array(forKey: storageKey) as? [Int] {
            savedPokemons = Set(saved)
        }
    }
}

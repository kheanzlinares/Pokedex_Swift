//
//  AboutView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 24/11/2024.
//
import SwiftUI

struct AboutView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    let pokemon: Pokemon

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AboutRow(title: "Name", value: pokemon.name.capitalized)
            AboutRow(title: "ID", value: String(format: "%03d", pokemon.id))
            AboutRow(title: "Base", value: "\(pokemonStore.pokemonDetails?.base_experience ?? 0) XP")
            AboutRow(title: "Weight", value: "\(pokemonStore.pokemonDetails?.weight ?? 0) kg")
            AboutRow(title: "Height", value: "\(pokemonStore.pokemonDetails?.height ?? 0) m")
            AboutRow(title: "Types", value: pokemonStore.pokemonType.map { $0.typeName.capitalized }.joined(separator: ", "))
            AboutRow(title: "Abilities", value: pokemonStore.pokemonAbilities.filter { !$0.is_hidden }.map { $0.abilityName.capitalized }.joined(separator: ", "))
        }
        .padding(.horizontal, 16)
    }
}


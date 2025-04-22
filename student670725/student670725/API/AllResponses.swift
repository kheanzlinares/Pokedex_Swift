//
//  AllResponses.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//

import Foundation

struct AllResponses: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonEntity]
}

struct PokemonEntity: Codable {
    let name: String
    let url: String
}

struct PokemonTypeDetails: Codable {
    let types: [PokemonTypes]
}

struct PokemonTypes: Codable {
    let type: specificTypes
}

struct specificTypes: Codable {
    let name: String
}

struct PokemonStatusDetails: Codable {
    let stats: [PokemonStatus]
}

struct PokemonStatus: Codable {
    let base_stat: Int
    let stat: specificTypes
}

struct SpecificStatus: Codable {
    let name: String
}

struct PokemonAbilitiesDetails: Codable {
    let abilities: [PokemonAbility]
}

struct PokemonAbility: Codable {
    let ability: SpecificAbility
    let is_hidden: Bool
}

struct SpecificAbility: Codable {
    let name: String
}

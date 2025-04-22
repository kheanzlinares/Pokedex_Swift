//
//  Pokemon.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//

import Foundation

struct APIConfig {
    static let spriteBaseURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
}

// MARK: - Pokemon
struct Pokemon: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let speciesUrl: String?

    var imageUrl: URL {
        return URL(string: "\(APIConfig.spriteBaseURL)\(id).png")!
    }
}

// MARK: - Pokemon Type
struct PokemonType: Identifiable, Equatable {
    let id: Int
    let typeName: String
}

// MARK: - Pokemon Page
struct PokemonPage: Codable {
    let count: Int
    let next: String?
    let results: [PokemonEntity] // Ensure this refers to the correct `PokemonEntity`
}


// MARK: - Pokemon Details
struct PokemonDetails: Codable {
    let id: Int
    let weight: Int
    let height: Int
    let base_experience: Int
    let name: String
    let species: Species
}

// MARK: - Pokemon Status
struct Pokemon_Status: Identifiable, Equatable {
    let id: Int
    let statusName: String
    let statusPercentage: Int
}

// MARK: - Pokemon Ability
struct PokemonAbilities: Identifiable, Equatable {
    let id: Int
    let abilityName: String
    let is_hidden: Bool
}

// MARK: - Evolution Chain
struct EvolutionChain: Codable {
    let chain: EvolutionChainLink
}

struct EvolutionChainLink: Codable {
    let species: Species
    let evolves_to: [EvolutionChainLink]
}

// MARK: - Evolution Node
struct EvolutionNode: Codable {
    let species: Species
    let evolves_to: [EvolutionNode]
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String

    var id: Int? {
        Int(url.split(separator: "/").last ?? "")
    }

    var imageUrl: URL? {
        guard let id = id else { return nil }
        return URL(string: "\(APIConfig.spriteBaseURL)\(id).png")
    }
}

// MARK: - Evolution Data
struct EvolutionData: Identifiable {
    let id: Int
    let name: String

    var imageUrl: URL {
        return URL(string: "\(APIConfig.spriteBaseURL)\(id).png")!
    }
}

// MARK: - Species Details Response
struct SpeciesDetailsResponse: Codable {
    let evolutionChain: EvolutionChainInfo

    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}

// MARK: - Evolution Chain Info
struct EvolutionChainInfo: Codable {
    let url: String
}


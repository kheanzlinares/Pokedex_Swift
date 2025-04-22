//
//  PokemonAPI.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//

import Foundation
import Combine

class PokemonAPI {
    
    // MARK: - Properties
    private var cancellables: [AnyCancellable] = []
    private let baseURL = "https://pokeapi.co/api/v2"
    private let itemsPerPage = 20
    
    // Type aliases for completion handlers
    typealias PokemonResult = Result<[Pokemon], Error>
    typealias PokemonTypeResult = Result<[PokemonType], Error>
    typealias PokemonStatsResult = Result<[Pokemon_Status], Error>
    typealias PokemonAbilitiesResult = Result<[PokemonAbilities], Error>
    
    // MARK: - Public Methods
    
    /// Fetch Pokémon list with pagination
    func fetchPokemonsWithPagination(offset: Int, completion: @escaping (PokemonResult) -> Void) {
        let urlString = "\(baseURL)/pokemon?limit=\(itemsPerPage)&offset=\(offset)"
        fetch(from: urlString, type: AllResponses.self) { result in
            switch result {
            case .success(let response):
                let pokemons = response.results.enumerated().map { (index, entity) in
                    Pokemon(
                        id: offset + index + 1,
                        name: entity.name,
                        speciesUrl: "\(self.baseURL)/pokemon-species/\(offset + index + 1)/"
                    )
                }
                completion(.success(pokemons))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch Pokémon types by ID
    func fetchPokeTypes(id: Int, completion: @escaping (PokemonTypeResult) -> Void) {
        guard let url = pokemonDetailURL(for: id)?.absoluteString else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        fetch(from: url, type: PokemonTypeDetails.self) { result in
            switch result {
            case .success(let response):
                let types = response.types.map { PokemonType(id: UUID().hashValue, typeName: $0.type.name) }
                completion(.success(types))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch detailed Pokémon information
    func getDetailedPokemon(id: Int, completion: @escaping (PokemonDetails) -> Void) {
        guard let url = pokemonDetailURL(for: id)?.absoluteString else { return }
        
        fetch(from: url, type: PokemonDetails.self) { result in
            if case .success(let data) = result {
                completion(data)
            }
        }
    }
    
    /// Fetch Pokémon stats by ID
    func fetchPokeStats(id: Int, completion: @escaping (PokemonStatsResult) -> Void) {
        guard let url = pokemonDetailURL(for: id)?.absoluteString else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        fetch(from: url, type: PokemonStatusDetails.self) { result in
            switch result {
            case .success(let response):
                let stats = response.stats.map {
                    Pokemon_Status(id: UUID().hashValue, statusName: $0.stat.name, statusPercentage: $0.base_stat)
                }
                completion(.success(stats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch Pokémon abilities by ID
    func fetchPokemonAbilities(id: Int, completion: @escaping (PokemonAbilitiesResult) -> Void) {
        guard let url = pokemonDetailURL(for: id)?.absoluteString else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        fetch(from: url, type: PokemonAbilitiesDetails.self) { result in
            switch result {
            case .success(let response):
                let abilities = response.abilities.map {
                    PokemonAbilities(id: UUID().hashValue, abilityName: $0.ability.name, is_hidden: $0.is_hidden)
                }
                completion(.success(abilities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch Pokémon evolution chain
    func fetchEvolutionChain(speciesUrl: String, completion: @escaping (Result<EvolutionChain, Error>) -> Void) {
        fetch(from: speciesUrl, type: SpeciesDetailsResponse.self) { result in
            switch result {
            case .success(let speciesDetails):
                guard let chainUrl = URL(string: speciesDetails.evolutionChain.url)?.absoluteString else {
                    completion(.failure(APIError.invalidURL))
                    return
                }
                self.fetch(from: chainUrl, type: EvolutionChain.self, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Build Pokémon detail URL
    private func pokemonDetailURL(for id: Int) -> URL? {
        URL(string: "\(baseURL)/pokemon/\(id)/")
    }
    
    /// Generic fetch function for decoding API responses
    private func fetch<T: Decodable>(from urlString: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        completion(.failure(error))
                    }
                },
                receiveValue: { response in
                    completion(.success(response))
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - Custom Error Handling

enum APIError: LocalizedError {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL provided."
        case .noData: return "No data received from the server."
        }
    }
}

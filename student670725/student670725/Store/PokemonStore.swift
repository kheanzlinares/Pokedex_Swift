//
//  PokemonStore.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//
import Foundation
import SwiftUI

class PokemonStore: ObservableObject {
    
    @Published var pokemons: [Pokemon] = []
    @Published var pokemonType: [PokemonType] = []
    @Published var pokemonStatus: [Pokemon_Status] = []
    @Published var pokemonAbilities: [PokemonAbilities] = []
    @Published var pokemonDetails: PokemonDetails?
    @Published var errorMessage: String?
    @Published var isLoadingEvolution: Bool = false
    @Published var evolutionError: String?
    @Published var evolutionChain: [Species] = []
    @Published var isLoadingPage = false

    private var favoritePokemons: [Pokemon] = []
    private var preloadedPokemonIDs: Set<Int> = []
    private var canLoadMorePages = true
    private let pokemonAPI = PokemonAPI()
    private let FAV_KEY = "fav_key"
    private var offsetCounter = 0
    
    init() {
        loadMoreContent()
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.offsetCounter = 0
            self.pokemons.removeAll()
        }
        loadMoreContent()
    }
    
    func loadMoreContentIfNeeded(currentItem item: Pokemon?) {
        guard let lastVisibleItem = item, lastVisibleItem.id == pokemons.last?.id else { return }
        loadMoreContent()
    }
    
    func loadMoreContent() {
        guard !isLoadingPage, canLoadMorePages else { return }
        
        DispatchQueue.main.async {
            self.isLoadingPage = true
            self.errorMessage = nil
        }

        pokemonAPI.fetchPokemonsWithPagination(offset: offsetCounter) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingPage = false
                
                switch result {
                case .success(let fetchedPokemons):
                    // Filter Pokémon to ensure they are in the current valid range
                    let validNewPokemons = fetchedPokemons.filter { fetched in
                        !self.pokemons.contains(where: { $0.id == fetched.id }) && fetched.id > self.offsetCounter && fetched.id <= self.offsetCounter + 20
                    }
                    self.pokemons.append(contentsOf: validNewPokemons)
                    self.offsetCounter += fetchedPokemons.count
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchMissingFavoritePokemons(favoriteIDs: Set<Int>) {
        let missingIDs = favoriteIDs.subtracting(favoritePokemons.map { $0.id })
        
        for id in missingIDs {
            pokemonAPI.getDetailedPokemon(id: id) { [weak self] details in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if !self.favoritePokemons.contains(where: { $0.id == details.id }) {
                        let newPokemon = Pokemon(id: details.id, name: details.name, speciesUrl: details.species.url)
                        self.favoritePokemons.append(newPokemon)
                    }
                }
            }
        }
    }
    
    func loadDataType(pokemon: Pokemon) {
        pokemonAPI.fetchPokeTypes(id: pokemon.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokeType):
                    self?.pokemonType = pokeType
                case .failure(let error):
                    print("Error loading types: \(error)")
                }
            }
        }
    }
    
    func getDetails(pokemon: Pokemon) {
        DispatchQueue.main.async {
            self.pokemonDetails = PokemonDetails.default
        }
        
        pokemonAPI.getDetailedPokemon(id: pokemon.id) { [weak self] data in
            DispatchQueue.main.async {
                self?.pokemonDetails = data
            }
        }
    }
    
    func loadStats(pokemon: Pokemon) {
        pokemonAPI.fetchPokeStats(id: pokemon.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokeStat):
                    self?.pokemonStatus = pokeStat
                case .failure(let error):
                    print("Error loading stats: \(error)")
                }
            }
        }
    }
    
    func loadAbilities(pokemon: Pokemon) {
        pokemonAPI.fetchPokemonAbilities(id: pokemon.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let abilities):
                    self?.pokemonAbilities = abilities
                case .failure(let error):
                    print("Error loading abilities: \(error)")
                }
            }
        }
    }
    
    func loadEvolutionChain(pokemon: Pokemon) {
        guard let speciesUrl = pokemon.speciesUrl else {
            DispatchQueue.main.async {
                self.evolutionError = "Species URL not found"
                self.isLoadingEvolution = false
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoadingEvolution = true
            self.evolutionError = nil
            self.evolutionChain.removeAll()
        }
        
        pokemonAPI.fetchEvolutionChain(speciesUrl: speciesUrl) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingEvolution = false
                
                switch result {
                case .success(let chain):
                    self.evolutionChain = self.flattenEvolutionChain(from: chain.chain)
                case .failure(let error):
                    self.evolutionError = error.localizedDescription
                }
            }
        }
    }

    private func flattenEvolutionChain(from link: EvolutionChainLink) -> [Species] {
        var speciesList = [Species]()
        var nodesToProcess = [link]

        while !nodesToProcess.isEmpty {
            let currentNode = nodesToProcess.removeFirst()
            speciesList.append(currentNode.species)
            nodesToProcess.append(contentsOf: currentNode.evolves_to)
        }
        return speciesList
    }
    
    func save(items: Set<Int>) {
        UserDefaults.standard.set(Array(items), forKey: FAV_KEY)
    }
    
    func load() -> Set<Int> {
        return Set(UserDefaults.standard.array(forKey: FAV_KEY) as? [Int] ?? [])
    }
    
    func formatter(value: Int) -> String {
        return String(format: "%.2f", Double(value) / 10)
    }
    
    func preloadFavorites(favoriteIDs: Set<Int>) {
        let missingIDs = favoriteIDs.subtracting(pokemons.map { $0.id })
        
        for id in missingIDs {
            pokemonAPI.getDetailedPokemon(id: id) { [weak self] details in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if !self.pokemons.contains(where: { $0.id == details.id }) {
                        let newPokemon = Pokemon(id: details.id, name: details.name, speciesUrl: details.species.url)
                        self.pokemons.append(newPokemon)
                    }
                }
            }
        }
    }
}

extension PokemonDetails {
    static let `default` = PokemonDetails(
        id: 0,
        weight: 0,
        height: 0,
        base_experience: 0,
        name: "Unknown",
        species: Species(name: "Unknown", url: "")
    )
}

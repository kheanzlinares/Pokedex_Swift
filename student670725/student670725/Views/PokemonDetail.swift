//
//  PokemonDetail.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 31/10/2024.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    @EnvironmentObject var favourites: Favourites
    @State private var selectedTab = "About"
    let pokemon: Pokemon
    @Binding var isDetailShowing: Bool
    @State private var isLoading = false
    @State private var initialScale: CGFloat = 0.2

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header with Pokémon ID and Types
                pokemonHeader

                // Pokémon Image
                pokemonImage

                // Tab Selector
                PageSelectorView(titles: ["About", "Stats", "Evolution"], selectedTab: $selectedTab)

                if selectedTab == "About" {
                    AboutView(pokemon: pokemon)
                } else if selectedTab == "Stats" {
                    StatsView(pokemon: pokemon)
                } else if selectedTab == "Evolution" {
                    EvolutionView(pokemon: pokemon)
                        .environmentObject(pokemonStore)
                }
            }
            .padding()
            .navigationTitle(pokemon.name.capitalized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    favouriteButton
                }
            }
            .onAppear {
                loadPokemonData()
                pokemonStore.loadEvolutionChain(pokemon: pokemon)
            }
        }
    }

    private var pokemonHeader: some View {
        HStack {
            ForEach(pokemonStore.pokemonType.map { $0.typeName.capitalized }, id: \.self) { type in
                Text(type)
                    .font(.subheadline).bold()
                    .foregroundColor(.white)
                    .padding(.init(top: 8, leading: 24, bottom: 8, trailing: 24))
                    .background(Color(.indigo))
                    .cornerRadius(20)
            }
            Spacer()
            Text("#\(pokemon.id)")
                .padding(.horizontal)
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }

    private var pokemonImage: some View {
        AsyncImage(url: pokemon.imageUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .frame(width: 250, height: 250)
                    .scaleEffect(initialScale)
                    .onAppear {
                        withAnimation {
                            initialScale = 1.0
                        }
                    }
            } else if phase.error != nil {
                Text("Image not available")
            } else {
                ProgressView()
            }
        }
        .padding(.top, -10)
    }

    private var favouriteButton: some View {
        Button(action: {
            favourites.toggleFavourite(pokemon)
        }) {
            let isFavourite = favourites.isFavourite(pokemon)
            Image(systemName: isFavourite ? "heart.fill" : "heart")
                .foregroundColor(isFavourite ? .red : .gray)
        }
    }

    private func loadPokemonData() {
        guard !isLoading else { return }
        isLoading = true

        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.pokemonStore.getDetails(pokemon: pokemon)
            group.leave()
        }

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.pokemonStore.loadDataType(pokemon: pokemon)
            group.leave()
        }

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.pokemonStore.loadStats(pokemon: pokemon)
            group.leave()
        }

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.pokemonStore.loadAbilities(pokemon: pokemon)
            group.leave()
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
}

struct AboutRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline).bold()
                .foregroundColor(.indigo)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

//
//  PokemonHomeView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 24/11/2024.
//

import SwiftUI

struct PokemonHomeView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    @Binding var searchText: String
    @State var isLoading: Bool
    @State var isLoadingMore: Bool

    var body: some View {
        ScrollView {
            VStack {
                SearchBarView(searchText: $searchText)
                    .padding(.horizontal)

                if let errorMessage = pokemonStore.errorMessage {
                    VStack {
                        Text("An error occurred: \(errorMessage)")
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            loadData()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else if isLoading {
                    ProgressView("Loading Pokémons...")
                        .padding()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(pokemonStore.pokemons.filter {
                            searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
                        }) { pokemon in
                            NavigationLink(
                                destination: PokemonDetailView(pokemon: pokemon, isDetailShowing: .constant(false))
                            ) {
                                PokemonCell(pokemon: pokemon)
                            }
                            .onAppear {
                                loadMoreData(last: pokemon)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                if isLoadingMore {
                    ProgressView("Loading more Pokémons...")
                        .padding()
                }
            }
        }
    }

    private func loadData() {
        isLoading = true
        pokemonStore.errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }

    private func loadMoreData(last: Pokemon) {
        guard !isLoadingMore else { return }
        if pokemonStore.pokemons.last == last {
            isLoadingMore = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoadingMore = false
                pokemonStore.loadMoreContentIfNeeded(currentItem: last)
            }
        }
    }
}

//
//  PokemonFavourites.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 31/10/2024.
//

import SwiftUI
import Combine

struct PokemonFavouritesView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    @EnvironmentObject var favourites: Favourites
    @EnvironmentObject var isDetailShowing: IsDetailShowing

    let gridItemLayout = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            Group {
                let favoritePokemons = pokemonStore.pokemons.filter { favourites.isFavourite($0) }
                
                if favoritePokemons.isEmpty {
                    VStack {
                        Spacer()
                        Text("No favourites have been added yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 16) {
                            ForEach(favoritePokemons) { pokemon in
                                NavigationLink(
                                    destination: PokemonDetailView(pokemon: pokemon, isDetailShowing: $isDetailShowing.isDetailShowing)
                                ) {
                                    PokemonCell(pokemon: pokemon)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Favourite Pokémons")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            favourites.objectWillChange.send()
            pokemonStore.preloadFavorites(favoriteIDs: favourites.savedPokemons)
        }
    }
}

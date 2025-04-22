//
//  ContentView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var pokemonStore = PokemonStore()
    @EnvironmentObject var favourites: Favourites
    @State private var searchText = ""
    @State private var tabSelection = 1
    @State private var isLoading = false
    @State private var isLoadingMore = false
    @State private var appStarted = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                tabContent(for: tabSelection)

                Spacer()

                // Custom Tab Bar
                CustomTabView(tabSelection: $tabSelection)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                    .background(Color.white)
                    .shadow(radius: 5)
            }
            .accentColor(.indigo)
            .onAppear {
                simulateLoading()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(pokemonStore)
    }

    // Tab view content with caching
    @ViewBuilder
    private func tabContent(for selection: Int) -> some View {
        if selection == 1 {
            PokemonHomeView(
                searchText: $searchText,
                isLoading: isLoading,
                isLoadingMore: isLoadingMore
            )
            .navigationTitle("Pokémons")
            .navigationBarTitleDisplayMode(.large)
            .transaction { transaction in
                transaction.animation = nil
            }
        } else if selection == 2 {
            PokemonFavouritesView()
                .navigationBarTitleDisplayMode(.large)
                .transaction { transaction in
                    transaction.animation = nil
                }
        }
    }

    private func simulateLoading() {
        if !appStarted {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
            }
        }
        appStarted = true
    }
}

//
//  student670725App.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 12/10/2024.
//

import SwiftUI

@main
struct student670725App: App {
    @StateObject var pokemonStore = PokemonStore()
    @StateObject var favourites = Favourites()
    @StateObject var isDetailShowing = IsDetailShowing()
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pokemonStore)
                .environmentObject(favourites)
                .environmentObject(isDetailShowing)
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 34)]
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 18)]
        appearance.shadowColor = nil

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

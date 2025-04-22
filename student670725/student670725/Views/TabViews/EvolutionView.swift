//
//  EvolutionView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 24/11/2024.
//
import SwiftUI

struct EvolutionView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    let pokemon: Pokemon

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                if pokemonStore.isLoadingEvolution {
                    ProgressView("Loading Evolution Chain...")
                } else if let error = pokemonStore.evolutionError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(Array(pokemonStore.evolutionChain.enumerated()), id: \.element.name) { index, species in
                        VStack(spacing: 0) {
                            EvolutionCardView(species: species)

                            // Add vertical dotted line only between cards
                            if index < pokemonStore.evolutionChain.count - 1 {
                                DottedLine()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .frame(width: 1, height: 30) // Adjust height for spacing
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            if pokemonStore.evolutionChain.isEmpty {
                pokemonStore.loadEvolutionChain(pokemon: pokemon)
            }
        }
    }
}

struct EvolutionCardView: View {
    let species: Species

    var body: some View {
        HStack {
            if let imageUrl = species.imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("#\(species.id ?? 0)")
                    .font(.caption)
                    .foregroundColor(.purple)
                Text(species.name.capitalized)
                    .font(.headline)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let dashHeight: CGFloat = 5
        let dashSpacing: CGFloat = 3
        var y: CGFloat = rect.minY

        while y < rect.maxY {
            path.move(to: CGPoint(x: rect.midX, y: y))
            y += dashHeight
            path.addLine(to: CGPoint(x: rect.midX, y: min(y, rect.maxY)))
            y += dashSpacing
        }
        return path
    }
}

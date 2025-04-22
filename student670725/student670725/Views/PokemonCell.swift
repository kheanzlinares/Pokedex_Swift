//
//  PokemonCell.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 06/11/2024.
//

import SwiftUI

struct PokemonCell: View {
    let pokemon: Pokemon
    let dimensions: Double = 120
    
    var body: some View {
        VStack {
            // ID Badge
            HStack {
                Text(String(format: "%03d", pokemon.id))
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.purple)
                    .cornerRadius(10)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.leading, 8)
            
            // Pokémon Image
            AsyncImage(
                url: pokemon.imageUrl,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: dimensions, height: dimensions)
                },
                placeholder: {
                    ProgressView()
                        .frame(width: dimensions, height: dimensions)
                }
            )
            .padding(.vertical, 8)
            
            Spacer()
            
            // Name and Options Icon
            HStack {
                Text(pokemon.name.capitalized)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.9))
        }
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 2)
        .frame(width: 150, height: 220)
    }
}

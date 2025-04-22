//
//  BarView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 31/10/2024.
//

import SwiftUI

struct BarView: View {
    var value: Int
    var title: String
    var color: Color = .purple
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title and Value Row
            HStack {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(value)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            
            // Progress Bar
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 6)
                    .foregroundColor(Color(.systemGray5))
                
                Capsule()
                    .frame(width: CGFloat(value) * 2, height: 6)
                    .foregroundColor(color)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
    }
}

struct BarChartView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(pokemonStore.pokemonStatus) { stat in
                BarView(value: stat.statusPercentage, title: "\(stat.statusName)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

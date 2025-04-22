//
//  StatusView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 24/11/2024.
//
import SwiftUI

struct StatsView: View {
    let pokemon: Pokemon

    var body: some View {
        VStack {
            BarChartView(pokemon: pokemon)
                .padding(.horizontal)
        }
    }
}

//
//  CustomTabView.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 31/10/2024.
//
import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int

    var body: some View {
        HStack(spacing: 150) {
            // Home Tab
            Button {
                tabSelection = 1
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: tabSelection == 1 ? "house.fill" : "house")
                        .font(.system(size: 25))
                        .foregroundColor(tabSelection == 1 ? .purple : .gray)
                    Text("Home")
                        .font(.caption)
                        .foregroundColor(tabSelection == 1 ? .purple : .gray)
                }
            }

            // Favourites Tab
            Button {
                tabSelection = 2
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: tabSelection == 2 ? "heart.fill" : "heart")
                        .font(.system(size: 25))
                        .foregroundColor(tabSelection == 2 ? .purple : .gray)
                    Text("Favourites")
                        .font(.caption)
                        .foregroundColor(tabSelection == 2 ? .purple : .gray)
                }
            }
        }
        .padding()
    }
}


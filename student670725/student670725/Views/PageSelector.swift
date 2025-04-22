//
//  PageSelector.swift
//  student670725
//
//  Created by Niña Kheaney Linares on 31/10/2024.
//
import SwiftUI

struct PageSelectorView: View {
    var titles: [String]
    @Binding var selectedTab: String
    
    var body: some View {
        Picker("Select Tab", selection: $selectedTab) {
            ForEach(titles, id: \.self) { title in
                Text(title).tag(title)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}


//
//  ComparisonView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 10/02/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct ComparisonSettingsView: View {
    let asteroids: [Asteroid]
    
    @Binding var showsComparison: Bool
    
    @State var comparisonType: Comparison
    
    var body: some View {
        VStack {
            Text("Comparison")
            Button("Begin") {
                print("Begin comparison")
                showsComparison = true
            }
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonSettingsView(
            asteroids: [], showsComparison: Binding.constant(false),
            comparisonType: Comparison.size
        )
    }
}

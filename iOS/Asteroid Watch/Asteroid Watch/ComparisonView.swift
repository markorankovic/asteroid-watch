//
//  ComparisonView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 10/02/2021.
//

import SwiftUI

struct ComparisonView: View {
    @State var is3D: Bool
        
    @State var comparisonType: Comparison
    
    var body: some View {
        VStack {
            Text("Comparison")
            Picker(
                selection: $comparisonType,
                label: Text("Please select a comparison")
            ) {
                ForEach(Comparison.allCases) {
                    Text("\($0.rawValue)")
                }
            }
            Toggle(
                "3D",
                isOn: $is3D
            )
            Button("Begin") {
                print("Begin comparison")
            }
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView(is3D: true, comparisonType: .size)
    }
}

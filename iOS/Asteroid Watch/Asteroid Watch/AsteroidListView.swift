//
//  AsteroidListView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 26/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct AsteroidListView: View {
    var asteroids: Binding<[Asteroid]>

    var sortBy: Sort
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Rotate for 3D comparison")
                        .frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 50)
                    let ƒ = asteroids.wrappedValue.sorted {
                        let comparator: Bool
                        switch sortBy {
                        case .potentiallyHazardous: comparator = $0.isHazardous && $0.diameter > $1.diameter
                        case .size: comparator = $0.diameter > $1.diameter
                        case .velocity: comparator = $0.velocity > $1.velocity
                        case .missDistance: comparator = $0.missDistance < $1.missDistance
                        }
                        return comparator
                    }
                    ForEach(ƒ, id: \.id) {
                        AsteroidViewItem(
                            asteroid: $0
                        )
                        .padding(.bottom, 50)
                    }
                    .animation(.easeInOut)
                }
            }
        }
        .background(
            Image("universe")
                .resizable()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        )
    }
}

struct AsteroidListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AsteroidListView(asteroids: Binding.constant([
                Asteroid(
                    id: "2517681",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                ),
                Asteroid(
                    id: "2517682",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                )
            ]), sortBy: .potentiallyHazardous)
            .previewDevice("iPhone 11")
            AsteroidListView(asteroids: Binding.constant([
                Asteroid(
                    id: "2517681",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                ),
                Asteroid(
                    id: "2517682",
                    name: "2015 DE198",
                    diameter: (1081.533506775 + 483.6764882185) / 2,
                    missDistance: 28047702.990978837,
                    velocity: 45093.5960746662,
                    date: nil,
                    isHazardous: true
                )
            ]), sortBy: .potentiallyHazardous)
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}

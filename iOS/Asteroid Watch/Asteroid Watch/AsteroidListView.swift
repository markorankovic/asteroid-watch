//
//  AsteroidListView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 26/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct AsteroidListView: View {
    let asteroids: [Asteroid]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    NavigationLink(destination: SearchView()) {
                        Text("Back").padding()
                    }
                    ForEach(asteroids, id: \.self) {
                        AsteroidView(asteroid: $0).padding()
                    }
                }
            }
        }
    }
}

struct AsteroidListView_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidListView(asteroids: [
            Asteroid(
                id: "2517681",
                name: "2015 DE198",
                diameter: (1081.533506775 + 483.6764882185) / 2,
                missDistance: 28047702.990978837,
                velocity: 45093.5960746662,
                date: nil,
                isHazardous: true
            )
        ])
    }
}

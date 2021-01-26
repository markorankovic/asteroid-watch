//
//  AsteroidView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 25/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct AsteroidView: View {
    
    let asteroid: Asteroid
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(asteroid.name)")
            Text("Hazardous: \(asteroid.isHazardous ? "Yes" : "No")")
            Text("Diameter: \(asteroid.diameter) km")
            Text("Velocity: \(asteroid.velocity) km/h")
            Text("Miss Distance: \(asteroid.missDistance) km")
        }
    }
    
}

struct AsteroidView_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidView(
            asteroid: Asteroid(
                id: "2517681",
                name: "2015 DE198",
                diameter: (1081.533506775 + 483.6764882185) / 2,
                missDistance: 28047702.990978837,
                velocity: 45093.5960746662,
                date: nil,
                isHazardous: true
            )
        )
    }
}

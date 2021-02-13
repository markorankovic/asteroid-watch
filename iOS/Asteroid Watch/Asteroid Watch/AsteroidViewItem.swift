//
//  AsteroidViewItem.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 06/02/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct AsteroidViewItem: View {
    var asteroid: Asteroid
    
    var body: some View {
        SpriteView(
            scene: AsteroidViewItemScene(asteroid: asteroid)
        )
        .aspectRatio(
            .init(width: 400, height: 300), contentMode: .fit
        )
    }
}

struct AsteroidViewItem_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidViewItem(
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

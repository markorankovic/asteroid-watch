//
//  AsteroidListView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 26/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct AsteroidListView: View {
    @EnvironmentObject var userData: UserData

    var sortBy: Sort
        
    func getComparator(a1: Asteroid, a2: Asteroid) -> Bool {
        let comparator: Bool
        switch sortBy {
        case .potentiallyHazardous: comparator = a1.isHazardous && a1.diameter > a2.diameter
        case .size: comparator = a1.diameter > a2.diameter
        case .velocity: comparator = a1.velocity > a2.velocity
        case .missDistance: comparator = a1.missDistance < a2.missDistance
        }
        return comparator
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Rotate for 3D comparison")
                    .frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 50)
                if userData.asteroidViewItems.count > 0 {
                    let ƒ = userData.asteroidViewItems.sorted {
                        return getComparator(
                            a1: $0.asteroid!,
                            a2: $1.asteroid!
                        )
                    }
                    ForEach(ƒ, id: \.self) {
                        AsteroidViewItem(scene: $0)
                            .padding(.bottom, 50)
                    }
                    .animation(.easeInOut)
                } else {
                    let ƒ = userData.asteroids.sorted {
                        return getComparator(a1: $0, a2: $1)
                    }
                    ForEach(ƒ, id: \.id) {
                        let asteroid = $0
                        let scene: AsteroidViewItemScene = {
                            let s = AsteroidViewItemScene(asteroid: asteroid)
                            self.userData.asteroidViewItems.append(s)
                            return s
                        }()
                        
                        AsteroidViewItem(scene: scene)
                            .padding(.bottom, 50)
                    }
                    .animation(.easeInOut)
                }
            }
        }
        .background(
            Image("universe")
                .ignoresSafeArea()
        )
    }
}

struct AsteroidListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AsteroidListView(sortBy: .potentiallyHazardous)
            .previewDevice("iPhone 11")
            AsteroidListView(sortBy: .potentiallyHazardous)
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}

//
//  AsteroidViewItem.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 06/02/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct AsteroidViewItem: View {
    //let tex: SKTexture
    
    let asteroid: Asteroid
    
    var body: some View {
        SpriteView(
            scene: AsteroidViewItemScene(asteroid: asteroid),
            options: [.allowsTransparency]
        )
        .aspectRatio(
            .init(width: 400, height: 200), contentMode: .fit
        )
//        Image(uiImage: UIImage(cgImage: tex.cgImage()))
//            .resizable()
//            .aspectRatio(contentMode: .fit)
    }
    
//    init(asteroid: Asteroid) {
////        let view = SKView(frame: .init(origin: .zero, size: .init(width: 400, height: 200)))
//        self.scene = AsteroidViewItemScene(asteroid: asteroid)
////        view.presentScene(scene)
////        let tex = view.texture(from: scene)!
////        self.tex = tex
//    }
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
        .previewDevice("iPhone 11")
    }
}

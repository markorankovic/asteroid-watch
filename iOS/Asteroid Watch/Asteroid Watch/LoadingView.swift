//
//  LoadingView.swift
//  LoadingScreen
//
//  Created by Marko Rankovic on 04/03/2021.
//

import SwiftUI
import SpriteKit

struct LoadingView: View {
    
    var body: some View {
        GeometryReader { g in
            SpriteView(
                scene: LoadingScene(size: g.size),
                options: [.allowsTransparency]
            )
                .background(
                    Image("universe")
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                )
        }
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
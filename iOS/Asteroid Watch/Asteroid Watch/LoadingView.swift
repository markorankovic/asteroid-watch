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
            NavigationView {
                SpriteView(
                    scene: LoadingScene(size: g.size),
                    options: [.allowsTransparency]
                )
                .background(
                    Image("universe")
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                )
            }
            .navigationBarItems( // Only for matching the image alignment with the InfoView
                leading:
                    HStack {
                        
                    }
            )
        }
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

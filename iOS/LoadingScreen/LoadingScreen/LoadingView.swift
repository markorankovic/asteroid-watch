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
        SpriteView(scene: LoadingScene())
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

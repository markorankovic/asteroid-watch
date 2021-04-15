//
//  Asteroid_WatchApp.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 22/01/2021.
//

import SwiftUI
import SpriteKit

@main
struct Asteroid_WatchApp: App {
        
    var body: some Scene {
        WindowGroup {
            MainView(errorOccurred: false)
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea()
        }
    }
        
}


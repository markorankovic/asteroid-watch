//
//  Asteroid_WatchApp.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 22/01/2021.
//

import SwiftUI

@main
struct Asteroid_WatchApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
        
}

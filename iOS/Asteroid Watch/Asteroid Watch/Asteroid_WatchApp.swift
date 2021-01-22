//
//  Asteroid_WatchApp.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 22/01/2021.
//

import SwiftUI

@main
struct Asteroid_WatchApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

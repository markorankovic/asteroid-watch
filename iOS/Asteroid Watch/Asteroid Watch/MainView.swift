//
//  MainView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 25/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct MainView: View {
    
    @State var asteroids: [Asteroid] = []
        
    @State var loading = false
    
    @State var errorOccurred: Bool
        
    var body: some View {
        if asteroids.isEmpty && (!loading || errorOccurred) {
            SearchView(errorOccurred: $errorOccurred, loading: $loading, asteroids: $asteroids)
        } else if !loading {
            InfoView(asteroids: $asteroids)
        } else {
            LoadingView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(errorOccurred: false)
    }
}

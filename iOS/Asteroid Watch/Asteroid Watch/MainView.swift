//
//  MainView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 25/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

public class UserData: ObservableObject {
    @Published public var asteroids: [Asteroid] = []
    public var asteroidViewItems: [AsteroidViewItemScene] = []
    var comparisonScene: SizeComparisonScene?
}

struct MainView: View {
    @State var errorOccurred: Bool
    
    @StateObject var userData = UserData()
    
    @State var loading: Bool
                
    var body: some View {
        if userData.asteroids.isEmpty && (!loading || errorOccurred) {
            SearchView(errorOccurred: $errorOccurred, loading: .constant(false))
                .environmentObject(userData)
        } else if !loading {
            InfoView()
                .environmentObject(userData)
        } else {
            LoadingView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(errorOccurred: false, loading: false)
    }
}

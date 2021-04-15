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
    @Published var loading: Bool = false
}

struct MainView: View {
    @State var errorOccurred: Bool
    
    @StateObject var userData = UserData()
                    
    var body: some View {
        if userData.asteroids.isEmpty && (!userData.loading || errorOccurred) {
            SearchView(errorOccurred: $errorOccurred)
                .environmentObject(userData)
        } else if !userData.loading {
            InfoView()
                .environmentObject(userData)
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

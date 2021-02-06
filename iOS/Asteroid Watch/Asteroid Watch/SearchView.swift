//
//  SearchView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 25/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct SearchView: View {
    @State var startDate: Foundation.Date = Date()
    @State var endDate: Foundation.Date = Date()
        
    let api = NASAAPI() // To be used statically
    
    @State var asteroids: [Asteroid] = []
    
    @State var errorOccurred: Bool = false
    
    var body: some View {
        if asteroids.isEmpty {
            VStack {
                Text("Welcome")
                DatePicker(
                    "Start Date",
                    selection: $startDate,
                    displayedComponents: .date
                )
                DatePicker(
                    "End Date",
                    selection: $endDate,
                    displayedComponents: .date
                )
                Button("Search") {
                    api.getAsteroids(
                        dateRange: .init(
                            uncheckedBounds: (
                                startDate,
                                endDate
                            )
                        )
                    ).sink(
                        receiveCompletion: { error in
                            // Handle error
                            print(error)
                            errorOccurred = true
                        },
                        receiveValue: { asteroids in
                            // Transition to asteroid list
                            print(asteroids)
                            self.asteroids = asteroids
                        }
                    ).store(in: &bag)
                }
                .alert(isPresented: $errorOccurred) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Error occurred."),
                        dismissButton: Alert.Button.destructive(Text("Ok")) {
                            errorOccurred = false
                        }
                    )
                }
            }
        } else {
            AsteroidListView(asteroids: asteroids)
        }
    }
}

var bag: [AnyCancellable] = []

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

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
                ).onChange(of: startDate, perform: { _ in
                    if startDate > endDate {
                        endDate = startDate
                    }
                })
                DatePicker(
                    "End Date",
                    selection: $endDate,
                    displayedComponents: .date
                ).onChange(of: endDate, perform: { _ in
                    if startDate > endDate {
                        startDate = endDate
                    }
                })
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
                            print("Received asteroids")
                            self.asteroids = asteroids.sorted(by: { a1, _ in
                                a1.isHazardous
                            })
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

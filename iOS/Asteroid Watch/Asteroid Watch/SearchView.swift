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
                    .padding(.bottom, 70)
                    .padding(.top, 50)
                    .font(.headline)
                Image("asteroid")
                    .resizable()
                    .padding(.horizontal, 20)
                Group {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    ).onChange(of: startDate, perform: { _ in
                        if startDate > endDate {
                            endDate = startDate
                        }
                    })
                    .padding(.top, 30)
                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        displayedComponents: .date
                    ).onChange(of: endDate, perform: { _ in
                        if startDate > endDate {
                            startDate = endDate
                        }
                    })
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 80)
                Button("Search") {
                    api.getAsteroids(
                        dateRange: .init(
                            uncheckedBounds: (
                                startDate,
                                endDate
                            )
                        )
                    ).sink(
                        receiveCompletion: { completion in
                            switch completion {
                            case .failure(_): errorOccurred = true
                            case .finished:
                                print("Done with no errors.")
                            }
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
                .padding(.bottom, 100)
            }
        } else {
            InfoView(asteroids: $asteroids, showsComparison: false)
        }
    }
}

var bag: [AnyCancellable] = []

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        //Group {
        Group {
            SearchView()
                .previewDevice("iPhone 11")
            SearchView()
                .previewDevice("iPhone 8")
        }
        //}
    }
}

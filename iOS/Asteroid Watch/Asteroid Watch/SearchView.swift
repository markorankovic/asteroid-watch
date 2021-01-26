//
//  SearchView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 25/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

//class AsteroidService: ObservableObject {
//
//    @Published var asteroids: [Asteroid] = []
//    @Published var error: String?
//
//    let api: AsteroidWatchAPIProtocol
//    var bag: Set<AnyCancellable> = []
//
//    init(api: AsteroidWatchAPIProtocol) {
//        self.api = api
//    }
//
//    func request(_ range: ClosedRange<AsteroidWatchAPI.Date>) {
//        api.getAsteroids(dateRange: range).sink { [weak self] error in
//            self?.error = "Error: \(error)"
//            self?.asteroids = []
//        }
//        receiveValue: { [weak self] asteroids in
//            self?.asteroids = asteroids
//        }
//        .store(in: &bag)
//    }
//}

struct SearchView: View {
    @State var startDate: Foundation.Date = Date()
    @State var endDate: Foundation.Date = Date()
        
    let api = NASAAPI()
    
    @State var asteroids: [Asteroid] = []
    
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
                                AsteroidWatchAPI.Date(
                                    day: 23, month: 5, year: 2021
                                ),
                                AsteroidWatchAPI.Date(
                                    day: 27, month: 5, year: 2021
                                )
                            )
                        )
                    ).sink(
                        receiveCompletion: { error in
                            // Handle error
                        },
                        receiveValue: { asteroids in
                            // Transition to asteroid list
                            self.asteroids = asteroids
                        }
                    ).store(in: &bag)
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

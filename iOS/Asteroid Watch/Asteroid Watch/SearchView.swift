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
    
    let api = NASAAPI()
    
    @State var asteroids: [Asteroid] = []
    
    @State var errorOccurred: Bool = false
    
    func getRange(startDate: Date, endDate: Date) -> ClosedRange<Date> {
        let startDate2 = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
        let endDate2 = Calendar.current.dateComponents([.year, .month, .day], from: endDate)
        print(startDate2)
        print(endDate2)
        return Calendar.current.date(from: startDate2)!...Calendar.current.date(from: endDate2)!
    }
    
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
                    ).onChange(of: startDate, perform: { value in
                        if value > endDate {
                            endDate = value
                        }
                    })
                    .padding(.top, 30)
                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        in: getRange(startDate: startDate, endDate: startDate.advanced(by: 3600 * 24 * 7)),
                        displayedComponents: .date
                    ).onChange(of: endDate, perform: { value in
                        if value < startDate {
                            startDate = value
                        }
                    })
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 80)
                Button("Search") {
                    api.getAsteroids(
                        dateRange: startDate...endDate
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
        Group {
            SearchView()
                .previewDevice("iPhone 11")
            SearchView()
                .previewDevice("iPhone 8")
        }
    }
}

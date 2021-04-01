//
//  SearchView.swift
//  Asteroid Watch
//
//  Created by Marko Rankovic on 25/01/2021.
//

import SwiftUI
import AsteroidWatchAPI

struct SearchView: View {
    
    let api = NASAAPI()

    @State var startDate: Foundation.Date = Date()
    @State var endDate: Foundation.Date = Date()

    @Binding var errorOccurred: Bool
    
    @Binding var loading: Bool
    
    @EnvironmentObject var userData: UserData
    
    func getRange(startDate: Date, endDate: Date) -> ClosedRange<Date> {
        let startDate2 = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
        let endDate2 = Calendar.current.dateComponents([.year, .month, .day], from: endDate)
        print(startDate2)
        print(endDate2)
        return Calendar.current.date(from: startDate2)!...Calendar.current.date(from: endDate2)!
    }
    
    var body: some View {
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
                )
                .padding(.top, 30)
                .onChange(of: startDate, perform: { [startDate] value in
                    endDate = self.startDate.advanced(by: startDate.distance(to: endDate))
                })
                .frame(width: 250, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                DatePicker(
                    "End Date",
                    selection: $endDate,
                    in: getRange(startDate: startDate, endDate: startDate.advanced(by: 3600 * 24 * 7)),
                    displayedComponents: .date
                )
                .padding(.bottom, 30)
                .frame(width: 250, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .padding(.horizontal, 80)
            Button("Search") {
                userData.asteroidViewItems = []
                loading = true
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
                        DispatchQueue.main.async {
                            // Transition to asteroid list
                            print("Received asteroids")
                            userData.asteroids = asteroids.sorted(
                                by: { a1, _ in
                                    a1.isHazardous
                                }
                            )
                            loading = false
                        }
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
    }
}

var bag: [AnyCancellable] = []

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView(errorOccurred: .constant(false), loading: .constant(false))
                .previewDevice("iPhone 11")
            SearchView(errorOccurred: .constant(false), loading: .constant(false))
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}

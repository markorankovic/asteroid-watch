import SwiftUI
import AsteroidWatchAPI

enum Sort {
    case potentiallyHazardous
    case size
    case velocity
    case missDistance
}

struct InfoView: View {
        
    var asteroids: Binding<[Asteroid]>
    
    @State var showsComparison: Bool = false
    
    @State var sortBy: Sort = .potentiallyHazardous
    
    //@State private var selectedTab = 1
    
//    @State var orientation = UIDevice.current.orientation
//
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()

//    let sizeChanged = UIScreen.main.publisher(for: \.bounds)
//        .makeConnectable()
//        .autoconnect()
    
    var body: some View {
        Group {
            if !showsComparison {
                NavigationView {
                    AsteroidListView(asteroids: asteroids, sortBy: sortBy)
                        .navigationBarItems(
                            leading:
                                HStack {
                                    Button(
                                        action: {
                                            self.asteroids.wrappedValue = []
                                        }
                                    ) {
                                        HStack {
                                            Image(systemName: "arrow.left")
                                            Text("Back")
                                        }
                                    }
                                },
                            trailing:                                     Menu(
                                content: {
                                    Button("Potentially Hazardous") {
                                        sortBy = .potentiallyHazardous
                                    }
                                    Button("Size") {
                                        sortBy = .size
                                    }
                                    Button("Velocity") {
                                        sortBy = .velocity
                                    }
                                    Button("Miss Distance") {
                                        sortBy = .missDistance
                                    }
                                },
                                label: {
                                    Text("Sort")
                                    Image(systemName: "arrow.up.arrow.down")
                                }
                            )
                        )
                }
            } else {
                ComparisonSequenceView(
                    comparisonScene: SizeComparisonScene3D(
                        asteroids: asteroids.wrappedValue
                    )
                )
            }
        }
        .onReceive(orientationChanged) { _ in
            let size = UIScreen.main.bounds.size
            if size.width > size.height {
                showsComparison = true
            } else {
                showsComparison = false
            }
        }
    }
    
}

struct SortMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "arrow.up.arrow.down")
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfoView(asteroids: Binding.constant(
                [
                    Asteroid(
                        id: "2517681",
                        name: "2015 DE198",
                        diameter: (1081.533506775 + 483.6764882185) / 2,
                        missDistance: 28047702.990978837,
                        velocity: 45093.5960746662,
                        date: nil,
                        isHazardous: true
                    )
                ]
            ), showsComparison: false)
            InfoView(asteroids: Binding.constant(
                [
                    Asteroid(
                        id: "2517681",
                        name: "2015 DE198",
                        diameter: (1081.533506775 + 483.6764882185) / 2,
                        missDistance: 28047702.990978837,
                        velocity: 45093.5960746662,
                        date: nil,
                        isHazardous: true
                    )
                ]
            ), showsComparison: false)
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}

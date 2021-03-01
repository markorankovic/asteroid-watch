import SwiftUI
import AsteroidWatchAPI

struct InfoView: View {
    var asteroids: Binding<[Asteroid]>
    
    @State var showsComparison: Bool = false
    
    //@State private var selectedTab = 1
    
    @State var orientation = UIDevice.current.orientation {
        willSet {
            if newValue == .portrait {
                showsComparison = false
            }
        }
    }
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()

    var body: some View {
        Group {
            if !orientation.isLandscape {
                NavigationView {
                    AsteroidListView(asteroids: asteroids)
                        .navigationBarItems(
                            leading: Button(
                                action: {
                                    self.asteroids.wrappedValue = []
                                }
                            ) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Back")
                                }
                            }
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
            self.orientation = UIDevice.current.orientation
        }
    }
    
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
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
    }
}

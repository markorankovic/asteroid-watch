import SwiftUI
import AsteroidWatchAPI

struct InfoView: View {
    var asteroids: Binding<[Asteroid]>
    
    @State private var selectedTab = 1
    
    var body: some View {
        NavigationView {
            TabView {
                AsteroidListView(asteroids: asteroids)
                    .onTapGesture {
                        self.selectedTab = 1
                    }
                    .tabItem {
                        Text("Asteroids")
                        Image(systemName: "list.bullet")
                    }
                    .tag(0)
                ComparisonView(is3D: false, comparisonType: .size)
                    .tabItem {
                        Text("Comparison")
                        Image(systemName: "aspectratio")
                    }
                    .tag(1)
            }.navigationBarItems(leading:
                Button(action: {
                    self.asteroids.wrappedValue = []
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                }
            )
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
        ))
    }
}

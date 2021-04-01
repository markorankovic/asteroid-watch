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
        
    @State var sortBy: Sort = .potentiallyHazardous
<<<<<<< HEAD
    
<<<<<<< HEAD
    @State var selection: Int = 0
    
=======
>>>>>>> parent of 34e45c5 (User data introduced & comparator defined in one place)
=======

>>>>>>> parent of d7181ae (ScrollView's position saved using TabView, transitioning between list and comparison lags)
    var body: some View {
        GeometryReader { g in
            if g.size.height > g.size.width {
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
                            trailing: Menu(
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
                .navigationViewStyle(StackNavigationViewStyle())
<<<<<<< HEAD
<<<<<<< HEAD
                .tag(0)
            
                Group {
                    if let scene = userData.comparisonScene {
                        ComparisonSequenceView(
                            comparisonScene: scene
                        )
                    } else {
                        let scene: SizeComparisonScene3D = {
                            let s = SizeComparisonScene3D(
                                asteroids: userData.asteroids
                            )
                            userData.comparisonScene = s
                            return s
                        }()
                        ComparisonSequenceView(
                            comparisonScene: scene
                        )
                    }
                }.tag(1)
            }
            .onChange(of: g.size) { _ in
                if g.size.height > g.size.width {
                    selection = 0
=======
            } else {
                if let scene = userData.comparisonScene {
                    ComparisonSequenceView(
                        comparisonScene: scene
                    )
>>>>>>> parent of d7181ae (ScrollView's position saved using TabView, transitioning between list and comparison lags)
                } else {
                    let scene: SizeComparisonScene3D = {
                        let s = SizeComparisonScene3D(
                            asteroids: userData.asteroids
                        )
                        userData.comparisonScene = s
                        return s
                    }()
                    ComparisonSequenceView(
                        comparisonScene: scene
                    )
                }
=======
            } else {
                ComparisonSequenceView(
                    comparisonScene: SizeComparisonScene3D(
                        asteroids: asteroids.wrappedValue
                    )
                )
>>>>>>> parent of 34e45c5 (User data introduced & comparator defined in one place)
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
            ))
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
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
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
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        }
    }
}

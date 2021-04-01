import SwiftUI
import AsteroidWatchAPI

enum Sort {
    case potentiallyHazardous
    case size
    case velocity
    case missDistance
}

struct InfoView: View {
        
    @EnvironmentObject var userData: UserData
    
    @State var sortBy: Sort = .potentiallyHazardous
    
    @State var selection: Int = 0
    
    var body: some View {
        GeometryReader { g in
            TabView(selection: $selection) {
                NavigationView {
                    AsteroidListView(sortBy: sortBy)
                        .environmentObject(userData)
                        .navigationBarItems(
                            leading:
                                HStack {
                                    Button(
                                        action: {
                                            userData.asteroids = []
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
                } else {
                    selection = 1
                }
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
            InfoView()
        }
    }
}

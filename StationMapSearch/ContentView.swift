import SwiftUI
import MapKit

struct Station: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedStation: Station?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var showingSearchSheet = false
    let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    
    let stations = [
        Station(name: "渋谷駅", coordinate: CLLocationCoordinate2D(latitude: 35.6580, longitude: 139.7016)),
        Station(name: "新宿駅", coordinate: CLLocationCoordinate2D(latitude: 35.6896, longitude: 139.7006)),
        Station(name: "中野駅", coordinate: CLLocationCoordinate2D(latitude: 35.7056, longitude: 139.6659)),
        Station(name: "東京駅", coordinate: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671)),
        Station(name: "池袋駅", coordinate: CLLocationCoordinate2D(latitude: 35.7295, longitude: 139.7109)),
        Station(name: "上野駅", coordinate: CLLocationCoordinate2D(latitude: 35.7141, longitude: 139.7774)),
        Station(name: "品川駅", coordinate: CLLocationCoordinate2D(latitude: 35.6284, longitude: 139.7387)),
        Station(name: "秋葉原駅", coordinate: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731)),
        Station(name: "六本木駅", coordinate: CLLocationCoordinate2D(latitude: 35.6641, longitude: 139.7315)),
        Station(name: "目黒駅", coordinate: CLLocationCoordinate2D(latitude: 35.6333, longitude: 139.7155)),
        Station(name: "恵比寿駅", coordinate: CLLocationCoordinate2D(latitude: 35.6462, longitude: 139.7103)),
        Station(name: "三軒茶屋駅", coordinate: CLLocationCoordinate2D(latitude: 35.6436, longitude: 139.6698)),
        Station(name: "原宿駅", coordinate: CLLocationCoordinate2D(latitude: 35.6710, longitude: 139.7025)),
        Station(name: "北千住駅", coordinate: CLLocationCoordinate2D(latitude: 35.7490, longitude: 139.8048)),
        Station(name: "大塚駅", coordinate: CLLocationCoordinate2D(latitude: 35.7315, longitude: 139.7285)),
        Station(name: "巣鴨駅", coordinate: CLLocationCoordinate2D(latitude: 35.7335, longitude: 139.7390)),
        Station(name: "代々木駅", coordinate: CLLocationCoordinate2D(latitude: 35.6836, longitude: 139.7020)),
        Station(name: "神田駅", coordinate: CLLocationCoordinate2D(latitude: 35.6918, longitude: 139.7709)),
        Station(name: "新橋駅", coordinate: CLLocationCoordinate2D(latitude: 35.6662, longitude: 139.7583)),
        Station(name: "飯田橋駅", coordinate: CLLocationCoordinate2D(latitude: 35.7022, longitude: 139.7519))
    ]
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: stations) { station in
                MapMarker(coordinate: station.coordinate)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                TextField("駅を検索", text: .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .disabled(true)
                                    .onTapGesture {
                                        showingSearchSheet = true
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                
                Button(action: {
                                    withAnimation {
                                        region = initialRegion
                                    }
                                }) {
                                    Image(systemName: "location.north.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 25))
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                .padding(.bottom)
            }
        }
        .sheet(isPresented: $showingSearchSheet) {
            SearchSheetView(searchText: $searchText, filteredStations: filteredStations, selectedStation: $selectedStation, region: $region, isPresented: $showingSearchSheet)
        }
    }
}

struct SearchSheetView: View {
    @Binding var searchText: String
    let filteredStations: [Station]
    @Binding var selectedStation: Station?
    @Binding var region: MKCoordinateRegion
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("駅名を入力", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(filteredStations) { station in
                    Button(action: {
                        selectedStation = station
                        region = MKCoordinateRegion(
                            center: station.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                        isPresented = false
                    }) {
                        Text(station.name)
                    }
                }
            }
            .navigationTitle("駅を検索")
            .navigationBarItems(trailing: Button("閉じる") {
                isPresented = false
            })
        }
    }
}

#Preview {
    ContentView()
}

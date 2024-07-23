//
//  ContentView.swift
//  Sip
//
//  Created by Vali Khan on 7/19/24.
//

import SwiftUI
import MapKit

struct Restaurant: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
    let rating: Double
}

// Extension to make MKCoordinateRegion conform to Equatable
extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude &&
               lhs.center.longitude == rhs.center.longitude &&
               lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
               lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7, longitude: -74.0),
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )
    
    @State private var restaurants: [Restaurant] = []
    @State private var selectedRestaurant: Restaurant? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, annotationItems: restaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        Button(action: {
                            selectedRestaurant = restaurant
                        }) {
                            Image("pinImage")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            .navigationTitle("Coffee Around Me")
            .background(
                NavigationLink(
                    destination: RestaurantDetailView(restaurant: selectedRestaurant ?? Restaurant(coordinate: CLLocationCoordinate2D(), name: "", rating: 0)),
                    isActive: .constant(selectedRestaurant != nil),
                    label: { EmptyView() }
                )
                .hidden()
            )
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReviewSubmitted"))) { _ in
                selectedRestaurant = nil
            }
        }
        .onAppear {
            searchForRestaurants()
        }
        .onChange(of: region) { _ in
            searchForRestaurants()
        }
    }
    
    private func searchForRestaurants() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Coffee Shop"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            
            let mapItems = response.mapItems
            var newRestaurants: [Restaurant] = []
            for item in mapItems {
                let restaurant = Restaurant(
                    coordinate: item.placemark.coordinate,
                    name: item.name ?? "Unknown",
                    rating: Double.random(in: 1...5) // Random rating for example purposes
                )
                newRestaurants.append(restaurant)
            }
            
            DispatchQueue.main.async {
                self.restaurants = newRestaurants
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

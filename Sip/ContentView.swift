//
//  ContentView.swift
//  Sip
//
//  Created by Vali Khan on 7/19/24.
//

import MapKit
import SwiftUI

struct Restaurant: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7, longitude: -74.0),
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )
    
    @State private var restaurants: [Restaurant] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, annotationItems: restaurants) { restaurant in
                    MapPin(coordinate: restaurant.coordinate, tint: .red)
                }
                .edgesIgnoringSafeArea(.all)
                
                HStack {
                    Button(action: {
                        zoomIn()
                        searchForRestaurants()
                    }) {
                        Text("Zoom In")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        zoomOut()
                        searchForRestaurants()
                    }) {
                        Text("Zoom Out")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Map View")
        }
        .onAppear {
            searchForRestaurants()
        }
    }
    
    private func zoomIn() {
        var newSpan = region.span
        newSpan.latitudeDelta /= 2
        newSpan.longitudeDelta /= 2
        region.span = newSpan
    }
    
    private func zoomOut() {
        var newSpan = region.span
        newSpan.latitudeDelta *= 2
        newSpan.longitudeDelta *= 2
        region.span = newSpan
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
                    name: item.name ?? "Unknown"
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

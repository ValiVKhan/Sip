//
//  RestaurantDetailView.swift
//  Sip
//
//  Created by Vali Khan on 7/23/24.
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @State private var showingReviewPage = false

    var body: some View {
        VStack {
            Text(restaurant.name)
                .font(.largeTitle)
                .padding()
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: restaurant.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )), annotationItems: [restaurant]) { restaurant in
                MapAnnotation(coordinate: restaurant.coordinate) {
                    Image("pinImage")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            .frame(height: 300)
            .padding()
            
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(restaurant.rating) ? "star.fill" : "star")
                        .foregroundColor(index < Int(restaurant.rating) ? .yellow : .gray)
                }
            }
            .font(.largeTitle)
            .padding()
            
            NavigationLink(destination: ReviewView(restaurant: restaurant), isActive: $showingReviewPage) {
                Button(action: {
                    showingReviewPage = true
                }) {
                    Text("Write a Review")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Details")
    }
}

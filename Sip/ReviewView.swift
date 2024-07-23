//
//  ReviewView.swift
//  Sip
//
//  Created by Vali Khan on 7/23/24.
//

import SwiftUI

struct ReviewView: View {
    let restaurant: Restaurant
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(restaurant.name)
                .font(.largeTitle)
                .padding()
            
            HStack {
                ForEach(1..<6) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(index <= rating ? .yellow : .gray)
                        .onTapGesture {
                            rating = index
                        }
                }
            }
            .font(.largeTitle)
            .padding()
            
            TextField("Write your review here...", text: $reviewText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 200)
            
            Button(action: {
                // Here, you would typically save the review to a database or backend service
                print("Rating: \(rating)")
                print("Review: \(reviewText)")
                presentationMode.wrappedValue.dismiss()
                NotificationCenter.default.post(name: NSNotification.Name("ReviewSubmitted"), object: nil)
            }) {
                Text("Submit Review")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Write a Review")
        .padding()
    }
}

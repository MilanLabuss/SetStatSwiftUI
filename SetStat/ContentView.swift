//
//  ContentView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Query var workouts: [Workout]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List(workouts) { workout in

                NavigationLink {
                    AddWorkoutView()
                } label: {
                    VStack {
                        Text(workout.name ?? "No name")
                    }
                }
               
               
            }
            .navigationTitle("Home")
            .toolbar {
                NavigationLink() {
                    AddWorkoutView()
                } label : {
                    Image(systemName: "plus.circle")
                        .resizable()
                           .frame(width: 24, height: 24)
                }

            }
        }
    }
}

#Preview {
    ContentView()
}

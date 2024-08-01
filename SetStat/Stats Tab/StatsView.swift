//
//  StatsView.swift
//  SetStat
//
//  Created by Milan Labus on 28/06/2024.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    
    
    @State private var sortOrder = SortDescriptor(\Workout.endTime, order: .reverse)
    //@Query var workouts: [Workout]
    
    //chatpgt give me a List of all Exercises from this workout Query
    
    var name = "Bench Press"
    
//    private var exercises: [Exercise] {
//        var allExercises: [Exercise] = []
//        for workout in workouts {
//            allExercises.append(contentsOf: workout.exercises ?? []) // Handle optional exercises array
//        }
//        return allExercises
//    }
    
    @Query var exerciseNames: [ExerciseName]
    
    var body: some View {
        
        NavigationStack {
            VStack {
    //            if exerciseName.isEmpty {
    //                ContentUnavailableView {
    //                    Label("No workouts yet", systemImage: "dumbbell.fill")
    //                } description: {
    //                    Text("Tap the workout tab below")
    //                }
    //               }
               // else {
                    List {
                        ForEach(exerciseNames) { exerciseName in
                            NavigationLink {
                                ExerciseStatsView(exerciseName: exerciseName)
                                
                            } label: {
                                Text("\(exerciseName.name)")
                            }
                        }
                    }
                //}
            }
        }
        
      
        
    }
}

#Preview {
    StatsView()
}

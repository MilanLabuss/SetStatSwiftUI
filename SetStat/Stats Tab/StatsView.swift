//
//  StatsView.swift
//  SetStat
//
//  Created by Milan Labus on 28/06/2024.
//

import SwiftUI
import SwiftData


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}


struct StatsView: View {
    
    
    @State private var sortOrder = SortDescriptor(\Workout.endTime, order: .reverse)
 
    @Query var exerciseNames: [ExerciseName]
    

    
    var body: some View {
        
        NavigationStack {

                
                List {
                    Section("Total Workouts") {
                        //chatgpt give this a tiny bit of elevation
                        NumberOfWorkoutsStat()
                    }
                    Section("By Exercise"){
                        ForEach(exerciseNames) { exerciseName in
                            ExerciseStatListTile(exerciseName: exerciseName)
                            
                        }
                    
                    }
     
                    
                }
                .listRowSpacing(15)
                .navigationTitle("Stats")
                
        
        }
       
    }
      
        
    
}

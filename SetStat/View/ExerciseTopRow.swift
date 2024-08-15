//
//  ExerciseTopRow.swift
//  SetStat
//
//  Created by Milan Labus on 13/08/2024.
//

import SwiftUI
import SwiftData

//The Top Row of each Exercise
struct ExerciseTopRow: View {
    
    var exercise: Exercise
    
    //Closure for Deleting the Passed Down Exercise
    var deleteExercise: () -> Void

     
     // This will return the previous exercise that matches this exerciseName
//     var previousExercise: Exercise? {
//         exercises.first
//     }
    
    
    var body: some View {
        HStack {
            Text("\(exercise.name)")
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            Spacer()
            
            //Chatgpt why is there a gray background bhind this elipsis image i dont want it to be gray i want no color
            Menu {

                Button(role: .destructive) {
                    deleteExercise()    //calling the closure to delete this current Exercise
                } label: {
                    Text("Delete")
                }
                .buttonStyle(.plain)
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray)
                    .padding()
            }
            .buttonStyle(.plain) // Apply plain button style to the Menu label
        }

    }
    
 
}



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
    
//    @Binding var showPreviousSheet: Bool
//    @Binding var previousExercise: Exercise?
//
//    
//    //chatgpt query all Exercises and find the first exericses whos ExerciseName matches this one and put it into a previousExercise Variable
//    @Query private var exercises: [Exercise]
//     
//    init(exercise: Exercise, deleteExercise: @escaping () -> Void, showPreviousSheet: Binding<Bool>, previousExercise: Binding<Exercise?>) {
//           self.exercise = exercise
//           self.deleteExercise = deleteExercise
//           self._showPreviousSheet = showPreviousSheet
//           self._previousExercise = previousExercise
//            
//           let currentExerciseId = exercise.id
//           let exerciseName = exercise.exerciseName.name
//            
//           _exercises = Query(filter: #Predicate<Exercise> {
//               $0.exerciseName.name == exerciseName && $0.id != currentExerciseId
//           }, sort: [
//               SortDescriptor(\Exercise.date, order: .reverse)
//           ])
//       }
     
     // This will return the previous exercise that matches this exerciseName
//     var previousExercise: Exercise? {
//         exercises.first
//     }
    
    
    var body: some View {
        HStack {
            Text("\(exercise.exerciseName.name)")
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            Spacer()
            
            Menu {
                
//                
//                Button {
//                    previousExercise = exercises.first
//                    showPreviousSheet = true
//
//                } label: {
//                    HStack {
//                        Text("Previous Exercise")
//                            .underline()
//                        Image(systemName: "repeat")
//                    }
//                }
//                .buttonStyle(.plain)
              
                
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
        }
//        .sheet(isPresented: $showPreviousSheet) {
//            PreviousExerciseView(previousExercise: previousExercise)
//                .presentationDragIndicator(.visible)
//        }
    }
    
 
}



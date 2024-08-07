//
//  PreviousExerciseView.swift
//  SetStat
//
//  Created by Milan Labus on 29/07/2024.
//

import SwiftUI

struct PreviousExerciseView: View {
    
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    //we can force unwrap this because the button isnt even shown if previousExercise is empty
    var previousExercise: Exercise?
    
    @Binding var sets: [MySet]


    
    
    var body: some View {
        if let exercise = previousExercise {
            VStack(spacing: 15) {
                List {
                    Section(header: Text(exercise.exerciseName.name)) {
                        if let exercisesets = exercise.sets {
                            ForEach(exercisesets) { set in
                                HStack(spacing: 10) {
                                    //Enter Reps and Weight
                                    HStack {
                                        VStack(alignment: .leading){
                                            Text("Kg")
                                                .foregroundStyle(.gray)
                                                .font(.subheadline)
                                            
                                            Text("\(set.weight)")
                                        }
                                        .frame(width: 45)
                                        .padding(.leading)
                                        //.background(.yellow)
                                        
                                        //Enter Reps
                                        VStack(alignment: .leading) {
                                            Text("Reps")
                                                .foregroundStyle(.gray)
                                                .font(.subheadline)
                                            Text("\(set.reps)")
                                            
                                            
                                            
                                        }
                                        .frame(width: 45)
                                        //.background(.blue)
                                    }
                                    
                                    Spacer()
                                    
                                    //Button to dublicate the current set and add it to the list
                                    Button {
                                        print("Current sets count: \(sets.count)")
                                        if(sets.count <= 7) {
                                            let weight = set.weight
                                            let reps = set.reps
                                            let newSet = MySet(id: UUID(),weight: weight, reps: reps, isCompleted: false, exercise: exercise)
                                            //chatgpt i have isolated that this line of code causes that problem why is this happening
                                            withAnimation {
                                                sets.append(newSet)
                                            }
                                            dismiss()
                                        }
                                        
                                        
                                    }
                                label: {
                                    Image(systemName: "plus.rectangle.on.rectangle")
                                }
                                .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
//        func saveSet(newSet: newSet) {
//            //first inserting the sets into the Sets model
//            
//            //currentExercise.sets?.append(newSet)
//            
//
//            
//            
//            
//            
//            //finished iterating through the sets and appending them so we can go back
//            dismiss()
//        }
        
    }
    
}
    


//
//  AddWorkoutView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var workoutName: String = ""
    @State private var showExercieSheet = false
    @State private var workoutStartTime = Date.now
    @State private var workoutEndTime = Date.now
    
    //I will build this temporary workout object then write it to the db
    @State private var workout: Workout = Workout(id: UUID())
 
    
    
    var body: some View {
        
        
        VStack {
            List {
                
                Section(header: Text("Workout Details")) {
                    
                    TextField("Enter workout name",text: $workoutName)
                    DatePicker("Start Time", selection: $workoutStartTime)
                    DatePicker("End Time", selection: $workoutEndTime)
                    
                }
                
                Section(header: Text("Exercises")) {
                    if let exercises =  workout.exercises {
                        ForEach(exercises){ exercise in
                            NavigationLink {
                                EditExeriseView(exercise: exercise, sets: exercise.sets ?? [])
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                
                                Text(exercise.exerciseName.name)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                            }
                        }
                        .onDelete(perform: delete)
                    } else {
                        Text("No Exericses Yet")
                    }
                   
                    //.onDelete(perform: delete)
                }
                
                
                
                Section {
                    Button {
                        showExercieSheet = true
                        
                    } label: {
                        Text("Add Exercise")
                        
                    }
                }
                
            }
            
            .listStyle(.insetGrouped)
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(workoutName)
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Save the Content (Everything is optional so just save it as Is but i will demand a name)
                    if(!workoutName.isEmpty) {
                        workout.name = workoutName
                        modelContext.insert(workout)
                        //chatgpt How do i now navigatte back home after this Operation?
                    }
       
                } label: {
                    Text("Save")
                        .font(.headline)
                        .underline()
                        .foregroundStyle(!workoutName.isEmpty ? .blue : .gray)
                        .fontWeight(.semibold)
                }
            }
        }
        
        .sheet(isPresented: $showExercieSheet) {
            
            AddExerciseView(workout: workout)
                .presentationDragIndicator(.visible)
            
        }
        
        
        
        
        
        
        
        
    }//End of Body
    //deleteing exercise Straight from Model context because we are working directly with a query here
    func delete(at offsets: IndexSet) {
        workout.exercises?.remove(atOffsets: offsets)
    }
    
    
}




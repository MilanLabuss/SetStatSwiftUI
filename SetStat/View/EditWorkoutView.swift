//
//  EditWorkoutView.swift
//  SetStat
//
//  Created by Milan Labus on 18/06/2024.
//

//
//  AddWorkoutView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
  
    //The Current workout that was clicked in the List

    
    let workout: Workout
    @State private var workoutName: String = ""
    @State private var workoutStartTime: Date = Date.now
    @State private var workoutEndTime: Date = Date.now
    
    @State private var showExercieSheet = false
    
 
    var body: some View {
        VStack {
            List {
                Section(header: Text("Workout Details")) {
                    
                    TextField("Enter workout name",text: $workoutName)
                    DatePicker("Start Time", selection: $workoutStartTime)
                    DatePicker("End Time", selection: $workoutEndTime)
                    
                }
                Section(header: Text("Exercises")) {
                    if let exercises =  workout.exercises?.sorted(by: { $0.date < $1.date }) {
                        ForEach(exercises){ exercise in
                            NavigationLink {
                                EditExeriseView(exercise: exercise, sets: exercise.sets ?? [])
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                
                                VStack(alignment:.leading) {
                                    Text(exercise.exerciseName.name)
                                        .fontWeight(.semibold)
                                        .padding(.top, 5)
                                        .padding(.bottom, 5)
                                        
                                    
                                    if let sets = exercise.sets {
                                        Text("\(sets.count)x Sets")
                                            .font(.system(size: 13))
                                            .foregroundStyle(.gray)
                                            
                                            
                                    }
                                        
                                    
                                }
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
            .animation(.easeIn(duration: 5), value: workout.exercises)
            .listStyle(.insetGrouped)
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    //we save the workout before going back since we are editing one here not creating it
                    if(!workoutName.isEmpty) {
                        workout.name = workoutName
                        workout.startTime = workoutStartTime
                        workout.endTime = workoutEndTime
                        modelContext.insert(workout)
                        dismiss()
                    }
                }label: {
                    Text("Back")
                        .foregroundStyle(.blue)
                        .underline()
                }
                
            }
            ToolbarItem(placement: .principal) {
                Text(workoutName)
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Save the Content (Everything is optional so just save it as Is but i will demand a name)
                    if(!workoutName.isEmpty) {
                        workout.name = workoutName
                        workout.startTime = workoutStartTime
                        workout.endTime = workoutEndTime
                        modelContext.insert(workout)
                        dismiss()
                        
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
        .onAppear {
            workoutName = workout.name
            workoutStartTime = workout.startTime
            workoutEndTime = workout.endTime
        
        }
        .sheet(isPresented: $showExercieSheet) {
            AddExerciseView(workout: workout)
                .presentationDragIndicator(.visible)
            
        }
//        .alert("Cancel", isPresented: $showCancelAlert) {
//            Button("Yes", role: .destructive) {
//                //Navigate back
//                dismiss()
//            }
//            Button("No", role: .cancel) {
//                
//            }
//            
//        } message: {
//            Text("Are you sure you want to cancel?")
//        }
        
        
        
        
        
        
        
        
    }//End of Body
    //deleteing exercise Straight from Model context because we are working directly with a query here
    func delete(at offsets: IndexSet) {
        workout.exercises?.remove(atOffsets: offsets)
    }
    
    
}




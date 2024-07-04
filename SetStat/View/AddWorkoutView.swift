//
//  AddWorkoutView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//
//The View for adding a Workout will look similar to the editWorkoutView but will have a cancel button instead of a back button
import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var workoutName: String = ""
    @State private var showExercieSheet = false
    @State private var workoutStartTime = Date.now
    @State private var workoutEndTime = Date.now
    
    //I will build this temporary workout object then write it to the db
    @State private var workout: Workout = Workout(id: UUID())
    
    // var workout: Workout
    
    @State private var showCancelAlert = false
    
    
    var body: some View {
        NavigationStack() {
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
                                    
                                }
                                label: {
                                Text(exercise.exerciseName.name)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                }
                            }
                            .onDelete(perform: delete)
                        } else {
                            Text("No Exericses Yet")
                        }
                    }
                    
                    
                    
                    Section {
                        Button {
                            showExercieSheet = true
                            
                        } label: {
                            Text("Add Exercise")
                            
                        }
                    }
                    
                }
                //                .navigationDestination(for: Exercise.self) { exercise in
                //                    EditExeriseView(exercise: exercise, sets: exercise.sets ?? [])
                //                        .navigationBarBackButtonHidden(true)
                //                }
                .listStyle(.insetGrouped)
                
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    showCancelAlert.toggle()
                }label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
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
        
        .sheet(isPresented: $showExercieSheet) {
            AddExerciseView(workout: workout)
                .presentationDragIndicator(.visible)
            
        }
        .alert("Cancel", isPresented: $showCancelAlert) {
            Button("Yes", role: .destructive) {
                //Navigate back
                dismiss()
            }
            Button("No", role: .cancel) {
                
            }
            
        } message: {
            Text("Are you sure you want to cancel?")
        }
        //        .onChange(of: workout.exercises) { oldExercises ,newExercises in
        //            guard let oldExercises = oldExercises, let newExercises = newExercises else {
        //                   return
        //               }
        //
        //               // Convert arrays to sets for efficient difference calculation
        //               let oldSet = Set(oldExercises)
        //               let newSet = Set(newExercises)
        //
        //               // Find exercises in newSet that are not in oldSet
        //               let addedExercises = Array(newSet.subtracting(oldSet))
        //
        //               // Now you have the added exercises in addedExercises array
        //               for exercise in addedExercises {
        //                   // Perform your work with the added exercise here
        //                   print("Added exercise: \(exercise)")
        //               }
        //
        //                }
        
        
        
        
        
        
        
        
    }//End of Body
    //deleteing exercise Straight from Model context because we are working directly with a query here
    func delete(at offsets: IndexSet) {
        workout.exercises?.remove(atOffsets: offsets)
    }
    
    
}




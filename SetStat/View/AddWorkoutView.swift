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
        VStack {
            List {
                Section(header: Text("Workout Details")) {
                    TextField("Enter workout name",text: $workoutName)
                    DatePicker("Start Time", selection: $workoutStartTime)
                        .onChange(of: workoutStartTime) {
                            if(workoutStartTime > workoutEndTime) {
                                workoutEndTime = workoutStartTime
                            }
                         
                        }
                    
                    DatePicker(
                        "End Time",selection: $workoutEndTime)
                    .onChange(of: workoutEndTime) { //not allowing endTime to be lower than StartTime
                        if(workoutEndTime < workoutStartTime) {
                            workoutStartTime = workoutEndTime
                        }
                     
                    }
                    
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
                        
                        // Update each exercise's date to the workout's end time
                        if let exercises = workout.exercises {
                              for exercise in exercises {
                                     exercise.date = workoutEndTime
                               }
                        }
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
                deleteWorkout() //if a exercise was added on this screen we need to delete it when cancelling the workout creation
                dismiss()
            }
            Button("No", role: .cancel) {
                //No will just dimiss the view
            }
            
        } message: {
            Text("Are you sure you want to cancel?")
        }
        
    }//End of Body
    
    
    
    // Function to delete the workout and its exercises
    func deleteWorkout() {
        if let exercises = workout.exercises {
            for exercise in exercises {
                modelContext.delete(exercise)
            }
        }
        modelContext.delete(workout)
    }
    
    //deleteing exercise Straight from Model context because we are working directly with a query here
    func delete(at offsets: IndexSet) {
        workout.exercises?.remove(atOffsets: offsets)
    }
    
    
}




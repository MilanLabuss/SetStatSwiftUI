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
 
    let workout: Workout

    //These will be Set in the OnAppear
    @State private var workoutName: String = ""
    @State private var workoutStartTime: Date = Date.now
    @State private var workoutEndTime: Date = Date.now
    
    @Query(sort: [SortDescriptor(\Exercise.date, order: .reverse)]) private var exercises : [Exercise]
    
    private var filteredExercises: [Exercise] {
        exercises.filter { $0.workout == workout }
    }
    
    //doing the exact same thing to get all the Sets of Each Exercise

    //show the sheet for adding a new Exercise
    @State private var showExercieSheet = false
    
    
//
//    @State private var showPreviousSheet = false
//    @State private var previousExercise: Exercise? = nil
    
 
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
              //  Section(header: Text("Exercises")) {
                        ForEach(filteredExercises){ exercise in
                            Section() {
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    ExerciseTopRow(
                                                    exercise: exercise,
                                                    deleteExercise: { deleteExercise(exercise) }
                                                    )
                                    
                                    Divider()
                                    
                                    SetsView(exercise: exercise)
                                    Divider()
                                    
                                    Button{
                                        if let exercisesets = exercise.sets {
                                            if(exercisesets.count <= 9) {
                                                let newSet = MySet(id: UUID(), weight: nil, reps: nil,isCompleted: false,date: Date.now , exercise: exercise)
                                                //ChatGpt I cannot see this being added until i Refresh the app
                                                modelContext.insert(newSet)
                                               
                                            }
                                        }
                                    }label: {
                                        Text("Add Set")
                                            .underline()
                                            .foregroundStyle(.blue)
                                            
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.top, 5)
                                    
                                    
                                }
                               
                               
                            }
                            
                        }
                //Im going to Replace this with a Button to either view the Previous Exercise or Delete the Entire Exercise
                        //.onDelete(perform: delete)
              //  }
//                            VStack(alignment: .leading) {
//                                    
//                                    Text("\(exercise.exerciseName.name)")
//                                    if let exercisesets = exercise.sets {
//                                        ForEach(exercisesets) { set in
//                                            //chatgpt i want 20 pixels of space vettewn each VStack
//                                                HStack {
//                                                    Text("\(set.weight)")
//                                                    Text("\(set.reps)")
//                                                }
//                                            
//                                        }
//                                        Divider()
//                                        Button{
//                                            if let exercisesets = exercise.sets {
//                                                if(exercisesets.count <= 7) {
//                                                    let newSet = MySet(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise)
//                                                    //ChatGpt I cannot see this being added until i Refresh the app
//                                                    modelContext.insert(newSet)
//                                                }
//                                            }
//                                        }label: {
//                                            Text("Add set")
//                                                .underline()
//                                        }
//                                    }
//                                }
                        
                                //EditExeriseView(exercise: exercise, sets: exercise.sets ?? [])
                            //}

                            
//                            NavigationLink {
//                                EditExeriseView(exercise: exercise, sets: exercise.sets ?? [])
//                                    .navigationBarBackButtonHidden(true)
//                            } label: {
//                                
//                                VStack(alignment:.leading) {
//                                    Text(exercise.exerciseName.name)
//                                        .fontWeight(.semibold)
//                                        .padding(.top, 5)
//                                        .padding(.bottom, 5)
//                                        
//                                    
//                                    if let sets = exercise.sets {
//                                        Text("\(sets.count)x Sets")
//                                            .font(.system(size: 13))
//                                            .foregroundStyle(.gray)
//                                            
//                                            
//                                    }
//                                        
//                                    
//                                }
//                            }
                      
                    
                    
                    
                  //  }
//                    else {
//                        Text("No Exericses Yet")
//                    }
                   
                    //.onDelete(perform: delete)
                    
                
                        
                  
               
                Section {
                    Button {
                        showExercieSheet = true
                        
                    } label: {
                        Text("Add Exercise")
                            .underline()
                        
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
                   // if(!workoutName.isEmpty) {
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
                    
                  //Setting the Tip Parameter to True
                    CopyWorkoutTip.workoutAdded = true
                    

 
                        dismiss()
                   // }
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
                    //if(!workoutName.isEmpty) {
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
                    
                    //Setting the Tip Parameter to True
                      CopyWorkoutTip.workoutAdded = true
                        
                        dismiss()
                        
                    //}
       
                } label: {
                    Text("Save")
                        .font(.headline)
                        .underline()
                        //.foregroundStyle(!workoutName.isEmpty ? .blue : .gray)
                        .foregroundStyle(.blue)
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
//        .sheet(isPresented: $showPreviousSheet) {
//            if let previousExercise = previousExercise {
//                           PreviousExerciseView(previousExercise: previousExercise)
//                               .presentationDragIndicator(.visible)
//                       }
//        }

    }//End of Body
    //deleteing exercise Straight from Model context because we are working directly with a query here
//    func delete(at offsets: IndexSet) {
//        let exercisesToDelete = filteredExercises
//               for index in offsets {
//                   let exercise = exercisesToDelete[index]
//                   modelContext.delete(exercise)
//               }
//    }
    
//    func delete(at offsets: IndexSet) {
//        let exercisesToDelete = filteredExercises
//        for index in offsets {
//            let exercise = exercisesToDelete[index]
//            
//            // Delete associated MySet objects first
//            if let sets = exercise.sets {
//                for set in sets {
//                    modelContext.delete(set)
//                }
//            }
//            
//            // Now delete the exercise itself
//            modelContext.delete(exercise)
//        }
//    }
    
    private func deleteExercise(_ exercise: Exercise) {

    
            
            // Delete associated MySet objects first
            if let sets = exercise.sets {
                for set in sets {
                    modelContext.delete(set)
                }
            }
            
            // Now delete the exercise itself
            modelContext.delete(exercise)
        

       }
    
    
}




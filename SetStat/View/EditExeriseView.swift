//
//  EditExeriseView.swift
//  SetStat
//
//  Created by Milan Labus on 13/06/2024.
//

import SwiftUI
import SwiftData


extension Formatter {
    static let valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""     // Show empty string instead of zero
        return formatter
    }()
}


struct EditExeriseView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    //This is passed down from the Parent View
    var exercise: Exercise
    
    //The user will temporarily write to this sets array than after he is done we will save it to exercises
    @State var sets: [MySet]
    
    @State private var showSheet = false
    @State private var showCancelAlert = false
    @State private var showPrevious = false

    
    @Query private var exercises: [Exercise]
        
    init(exercise: Exercise, sets: [MySet], showSheet: Bool = false, showCancelAlert: Bool = false, showPrevious: Bool = false) {
        self.exercise = exercise
        self.sets = sets
        self.showSheet = showSheet
        self.showCancelAlert = showCancelAlert
        self.showPrevious = showPrevious
        let currentexerciseid = exercise.id
                let exercisesName = exercise.exerciseName.name
                _exercises = Query(filter: #Predicate<Exercise> {
                    $0.exerciseName.name == exercisesName &&  $0.id != currentexerciseid
                        },
                         sort: [
                            SortDescriptor(\Exercise.date, order: .reverse)
                            ]
                                   
                )
    }
    
    //This will return the previous exercise that matches this exerciseName to be used in PreviousExercise Button
    var previousExercise: Exercise? {
        exercises.first
        
    }
    

    var body: some View {
        VStack(spacing: 15) {
            //The List of all Sets
            List {
                Section(header: Text("Sets")) {
                    ForEach($sets){ $set  in
                        //HStack for Editing the Details of a Set
                        HStack(spacing: 10) {
                            Group {
                                if(set.isCompleted) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green) // Using the custom color
                                        .font(.system(size: 22)) // Adjust the size here
                                    
                                } else {
                                    Image(systemName: "circle")
                                        .font(.system(size: 22)) // Adjust the size here
                                }
                            }
                            .onTapGesture {
                                if(set.reps != 0 && set.weight != 0) {
                                    set.isCompleted.toggle()
                                }
                            }
                            //Enter Reps and Weight
                            HStack {
                                VStack(alignment: .leading){
                                    Text("Kg")
                                        .foregroundStyle(.gray)
                                        .font(.subheadline)
                                    //Chatgpt ia m having problems with these TextFields and its when im editting an old reps or weight i cant delete the number
                                    //already there to add a new one it wont let the reps of weight TextField Become empty
                                    TextField("\(set.weight)", value: $set.weight, formatter:Formatter.valueFormatter)
                                        .keyboardType(.decimalPad)
                                    
                                    
                                    
                                }
                                .frame(width: 45)
                                .padding(.leading)
                                //.background(.yellow)
                                
                                //Enter Reps
                                VStack(alignment: .leading) {
                                    Text("Reps")
                                        .foregroundStyle(.gray)
                                        .font(.subheadline)
                                    TextField("\(set.reps)", value: $set.reps,formatter:Formatter.valueFormatter)
                                        .keyboardType(.decimalPad)
                                    
                                    
                                    
                                }
                                .frame(width: 45)
                                //.background(.blue)
                            }
                            
                            Spacer()
                            
                            //Button to dublicate the current set and add it to the list
                            //chatgpt i made a discovery even this dupilicate button will allow me to make weight and reps 0 even thouhg its a complete copy of another set,
                            //so why cant i make weight and reps of an existing Set 0?
                            Button {
                                print("Current sets count: \(sets.count)")
                                if(sets.count <= 7) {
                                    let weight = set.weight
                                    let reps = set.reps
                                    let newSet = MySet(id: UUID(),weight: weight, reps: reps, isCompleted: false, exercise: exercise)
                                    withAnimation {
                                        sets.append(newSet)
                                    }
                                }
                                
                                
                            }
                        label: {
                            Image(systemName: "plus.rectangle.on.rectangle")
                        }
                        .buttonStyle(.borderless)
                        }
                        
                        
                        
                    } //END for each
                    
                    .onDelete(perform: delete)
                    .deleteDisabled(sets.count < 2) //making sure you have to have at least one Set
                    
                    //End of List Items
                }
                //Adding a New Set to the Temporary Array
                Section {
                    Button{
                        if(sets.count <= 7) {
                            let newSet = MySet(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise)
                            withAnimation {
                                sets.append(newSet)
                            }
                        }
                    }label: {
                        Text("Add set")
                            .underline()
                    }
                }
                
                //Showing a pop up of last weeks workout if there is one with the same WorkoutName
                if previousExercise != nil {
                    Section {
                        Button {
                            showPrevious.toggle()
                        } label: {
                            Text("Previous \(exercise.exerciseName.name)")
                                .underline()
                        }
                    }
                }
                
                
                
            }
            .listStyle(.automatic)
            
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    showCancelAlert.toggle()
                }label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                        .underline()
                }
                
            }
            ToolbarItem(placement: .principal) {
                Text(exercise.exerciseName.name)
                    .fontWeight(.semibold)
            }
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    save()
                }label: {
                    Text("Done")
                        .foregroundStyle(.blue)
                        .underline()
                }
                //.id(UUID())
                
            }
        }
        .onAppear {
            //this will check if the exercise has sets and if it does we will put them into State but if its doesnt we will create 2
            // exercise = exercise
            if let newSets = exercise.sets {    //unwrapping the passed exercises sets
                if (!newSets.isEmpty) {     //we passed actual sets in so set them to our sets
                   //Copy over all of those Sets into new Sets
                    sets = newSets
                    
                    
                }
                else {      //the exercise had no sets meaning an empty array was passed so we fill it with our mock Sets
                    sets = [MySet(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise), MySet(id: UUID(), weight: 0, reps: 0, isCompleted: false, exercise: exercise)]
                }
                sortSets()
                
            }
            //The optional exercise sets array was empty so load default (0) sets into State
            else {
                sets = [MySet(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise), MySet(id: UUID(), weight: 0, reps: 0, isCompleted: false, exercise: exercise)]
                sortSets()
            }
        }
        .sheet(isPresented: $showPrevious) {
            PreviousExerciseView(previousExercise: previousExercise, sets: $sets)
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
//        .sheet(item: ) 
        
        
    }//End of View Hierarchy
    
    
    func delete(at offsets: IndexSet) {
        sets.remove(atOffsets: offsets)
        exercise.sets?.remove(atOffsets: offsets)
    }
    
    // Sorting the sets by weight from smallest to largest
    private func sortSets() {
        sets.sort { $0.weight < $1.weight }
    }
    
    //Saving all of the Sets that were marked as Complete
    func save() {
        //first inserting the sets into the Sets model
        for set in sets {
            if(set.isCompleted){
                modelContext.insert(set)
                exercise.sets?.append(set)
                print("\(exercise.sets!)")
                print("\(sets)")
                //  exercise.sets?.append(set)
            } else {
                print("this set was not toggled")
            }
            
        }
        //finished iterating through the sets and appending them so we can go back
        dismiss()
    }
    
}


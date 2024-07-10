//
//  EditExeriseView.swift
//  SetStat
//
//  Created by Milan Labus on 13/06/2024.
//

import SwiftUI
import SwiftData


struct EditExeriseView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    //This is passed down from the Parent View
    var exercise: Exercise
    
    //The user will temporarily write to this sets array than after he is done we will save it to exercises
    @State var sets: [Set]
    
    
    @State private var showSheet = false
    @State private var showCancelAlert = false
    
    
    //this will check if the exercise has sets and if it does we will put them into State but if its doesnt we will create 2
    //    init(exercise: Exercise, sets: [Set]) {
    //        self.exercise = exercise
    //        if let newSets = exercise.sets {    //unwrapping the passed exercises sets
    //            if (!newSets.isEmpty) {     //we passed actual sets in so set them to our sets
    //                self.sets = newSets
    //            }
    //            else {      //the exercise had no sets meaning an empty array was passed so we fill it with our mock Sets
    //                self.sets = [Set(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise),Set(id: UUID(), weight: 0, reps: 0, isCompleted: false, exercise: exercise)]
    //            }
    //
    //        }
    //        //The optional exercise sets array was empty so load default
    //        else {
    //            self.sets = [Set(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise),Set(id: UUID(), weight: 0, reps: 0, isCompleted: false, exercise: exercise)]
    //        }
    //    }
    
    
    var body: some View {
        VStack(spacing: 15) {
            List {
                Section(header: Text("Sets")) {
                    ForEach($sets){ $set  in
                        HStack(spacing: 10) {
                            //The CheckMark Button
                            //                            Image(
                            //                                systemName: set.isCompleted ?
                            //                                "checkmark.circle" :
                            //
                            //                                    "circle"
                            //                            )
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
                                    
                                    TextField("\(set.weight)", value: $set.weight, formatter: NumberFormatter())
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
                                    TextField("\(set.reps)", value: $set.reps, formatter: NumberFormatter())
                                        .keyboardType(.decimalPad)
                                    
                                    
                                    
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
                                    let newSet = Set(id: UUID(),weight: weight, reps: reps, isCompleted: false, exercise: exercise)
                                    sets.append(newSet)
                                }
                                
                                
                            }
                        label: {
                            Image(systemName: "plus.rectangle.on.rectangle")
                        }
                        .buttonStyle(.borderless)
                        }
                        
                        
                        
                    }
                    
                    .onDelete(perform: delete)
                    .deleteDisabled(sets.count < 2) //making sure you have to have at least one Set
                    
                    //End of List Items
                }
                //Adding a New Set to the Temporary Array
                Section {
                    Button{
                        if(sets.count <= 7) {
                            let newSet = Set(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise)
                            sets.append(newSet)
                        }
                    }label: {
                        Text("Add set")
                            .underline()
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
                    sets = newSets
                }
                else {      //the exercise had no sets meaning an empty array was passed so we fill it with our mock Sets
                    sets = [Set(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise),Set(id: UUID(), weight: 0, reps: 0, isCompleted: false, exercise: exercise)]
                }
                
            }
            //The optional exercise sets array was empty so load default
            else {
                sets = [Set(id: UUID(), weight: 0, reps: 0,isCompleted: false, exercise: exercise),Set(id: UUID(), weight: 0, reps: 0, isCompleted: false, exercise: exercise)]
            }
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
        
    }
    func delete(at offsets: IndexSet) {
        sets.remove(atOffsets: offsets)
        exercise.sets?.remove(atOffsets: offsets)
        
        //chatgpt i need to find this set in Exercise
        
        
    }
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


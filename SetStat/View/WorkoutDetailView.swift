//
//  WorkoutDetailView.swift
//  SetStat
//
//  Created by Milan Labus on 11/07/2024.
//

import SwiftUI
import SwiftData

//Will show all of the statistics of the Workout
struct WorkoutDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let workout: Workout
    
 
    @Query var exercises: [Exercise]
    
    
    
    var duration: Int? {
        Calendar.current.dateComponents([.minute], from: workout.startTime, to: workout.endTime).minute
    }
    
    private var filteredExercises: [Exercise] {
           exercises.filter { $0.workout == workout } // Filter exercises for the current workout
       }
    
    //chatgpt lets use sets here and filter it where theSets parents Exercises workout matches the current Workout
    
    
    @Query var sets: [MySet]
    
    
    //total weight for all exercises
    var volume: Int {
        var totalVolume = 0
       // if let exercises = filteredExercises {
            for exercise in filteredExercises {
                let filteredSets = sets.filter { $0.exercise == exercise }
                    for set in filteredSets {
                        totalVolume += set.weight
                    }
                
                
            }
       // }
        return totalVolume
    }
    //total number of sets for all exercises
    var totalSets: Int {
        var totalSets = 0
       // if let exercises = filteredExercises {
            for exercise in filteredExercises {
                let filteredSets = sets.filter { $0.exercise == exercise }
                    for _ in filteredSets {
                             totalSets += 1
                    }
                
                
            }
       // }
        return totalSets
    }
    
    //computed Value that Ensures there are no Exercises whos only set is a  0 0 set
//    private var filteredExercises: [Exercise] {
//        if let exercises = workout.exercises {
//            return exercises.filter { exercise in
//                guard let sets = exercise.sets else { return false }
//                // Return true if there is at least one valid set
//                return sets.contains { $0.weight != 0 || $0.reps != 0 }
//            }
//        }
//        return []
        
        //chatgpt return a list of exercises whos workout is that passed down workout
//    }
    
 
    
    
    var body: some View {
            ScrollView {
                //The Toolbar
                VStack {
                    ZStack {
                        HStack{
                          
                            Button{
                                dismiss()
                            }label: {
                                Text("Back")
                                    .foregroundStyle(.blue)
                                    .underline()
                            }
                            
                            Spacer()
                        }
       
                        HStack{ Spacer()
                            Text(workout.endTime, format: .dateTime.day().month().year())
                                .font(.system(size: 15))
                            Spacer() }
                    }
                    
                }
                .frame(height: 25)
                .padding()
                
                VStack(spacing: 40) {
                    
                    //Workout Name
                    HStack {
                        Text("\(workout.name)")
                            .font(.title)
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    
                    //The 3 totals HStack
                    HStack(spacing: 10) {
                        //Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "stopwatch.fill")
                            Text("Duration")
                                .foregroundStyle(.gray)
                                .font(. system(size: 19))
                            HStack(spacing: 4) {
                                if duration! == 0 {
                                    Text("-")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 17))
                                }else {
                                    Text("\(duration!)")
                                        .fontWeight(.semibold)
                                        .font(. system(size: 17))
                                    Text("Min")
                                        .font(. system(size: 16))
                                }
                                
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack(spacing: 8) {
                            Image(systemName: "scalemass.fill")
                            Text("Volume")
                                .foregroundStyle(.gray)
                                .font(. system(size: 19))
                            HStack(spacing: 3) {
                                Text("\(volume)")
                                    .fontWeight(.semibold)
                                    .font(. system(size: 17))
                                Text("Kg")
                                    .font(. system(size: 16))
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        VStack(spacing: 8) {
                            Image(systemName: "dumbbell.fill")
                            Text("Sets")
                                .foregroundStyle(.gray)
                                .font(. system(size: 19))
                            
                            Text("\(totalSets)")
                                .fontWeight(.semibold)
                                .font(. system(size: 17))
                            
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        //Spacer()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    //  .padding(.horizontal, 40)
                    
                    //Exercise List Section
                    HStack {
                        Text("Exercises").font(.title2).fontWeight(.bold)
                        Spacer()
                    }
                    Section {
                      //  if let exercises = workout.exercises {
                            ForEach(filteredExercises) { exercise in
                            
                                DetailViewExercisesList(exercise: exercise)
                        }
                    } //END exercise Section
         
                    
                   
                    
                    
                } //End outer VStack
                .padding()
            }
            .background(
                VStack(spacing: .zero) {
                   
                    Color(.clear)
                     
                    //Chatgpt i want this one to be slighly taller than half the screen
                    Color(red: 70/255, green: 130/255, blue: 180/255)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 8
                            )
                        )
                }
                    .ignoresSafeArea()
                )
  
        
        
        
        
        
    }
}


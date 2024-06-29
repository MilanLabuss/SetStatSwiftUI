//
//  ContentView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    
    static var fetchDescriptor: FetchDescriptor<Workout> {
        var descriptor = FetchDescriptor<Workout>(
            sortBy: [
                
                SortDescriptor(\.endTime, order: .reverse)
            ]
        )
        descriptor.fetchLimit = 6
        return descriptor
    }
    
    @Query(fetchDescriptor) private var workouts: [Workout]
    
    @Environment(\.modelContext) var modelContext
    @State private var showDuplicateButton = false
    
    
    var body: some View {
        NavigationStack {
            
            
            if workouts.isEmpty {
                ContentUnavailableView {
                    Label("No workouts yet", systemImage: "dumbbell.fill")
                } description: {
                    Text("Tap the button below to get started")
                } actions: {
                    NavigationLink() {
                        AddWorkoutView()
                            .navigationBarBackButtonHidden(true)
                    } label : {
                        Text("Start Workout")
                            .underline()
                        
                    }
                }
            }
            
            else {
                List {
                    Section(header: Text("Recent Workouts")) {
                        ForEach(workouts) { workout in
                            NavigationLink {
                                EditWorkoutView(workout: workout)
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                //The UI of each List Item
                                HStack(spacing: 19) {
                                    
                                    if showDuplicateButton {
                                        Button {
                                            //the workout copy method uses the exercises copy method to copy all exercises which itself does the same for its sets
                                            let newWorkout = workout.copy()
                                            modelContext.insert(newWorkout)
                                            showDuplicateButton.toggle()
                                            
                                        }
                                    label: {
                                        Image(systemName: "plus.rectangle.on.rectangle")
                                    }
                                    .buttonStyle(.borderless)
                                    }
                                    
                                    if let endTime = workout.endTime {      //i know this wont be nil but still best to provide a default anyway
                                        VStack(spacing: 0) {
                                            Text(endTime.formatted(.dateTime.weekday()))
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                                .padding([.top, .leading, .trailing], 5)
                                                .padding([.bottom], 2)
                                                .background(Color(red: 70/255, green: 130/255, blue: 180/255))
                                                .clipShape(
                                                    .rect(
                                                        topLeadingRadius: 5,
                                                        bottomLeadingRadius: 0,
                                                        bottomTrailingRadius: 0,
                                                        topTrailingRadius: 5
                                                    )
                                                )
                                            Text(endTime.formatted(.dateTime.day(.twoDigits)))
                                                .frame(maxWidth: .infinity)
                                                .font(.system(size: 16))
                                                .padding([.top], 2)
                                                .padding([.bottom], 5)
                                        }
                                        .frame(width: 42)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black.opacity(0.4), lineWidth: 1)
                                        )
                              
                                    } else {
                                        Text("")
                                    }
                                    //chatgpt why is my workout.name and exercises text not aligned?
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(workout.name ?? "No name")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 18, weight: .semibold, design: .default))
                                        
                                        //The Stats
                                        if let exercises =  workout.exercises {
                                            Text("\(exercises.count)x Exercises")
                                                .font(.system(size: 13))
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                }
                .navigationTitle("Home")
                .toolbar {

                    ToolbarItem(placement: .topBarLeading) {
                        Button(showDuplicateButton ? "Done" : "Repeat") {
                            showDuplicateButton.toggle()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink() {
                            AddWorkoutView()
                                .navigationBarBackButtonHidden(true)
                        } label : {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                }
            }
           
        }
    }
}

#Preview {
    ContentView()
}

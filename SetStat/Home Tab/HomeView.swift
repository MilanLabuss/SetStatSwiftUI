//
//  ContentView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData

//Testing Testing

struct HomeView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var showDuplicateButton = false
    @State private var isRotating = false
    @State private var selectedDate: Date = Date.now
    
   // @State private var sortOrder = SortDescriptor(\Workout.endTime, order: .reverse)
    
    
    
    
    static var fetchDescriptor: FetchDescriptor<Workout> {

        let descriptor = FetchDescriptor<Workout>(
            // predicate: #Predicate { $0.endTime == selectedDate },
            sortBy: [
                .init(\.endTime, order: .reverse)
            ]
        )
        //descriptor.fetchLimit = 6
        return descriptor
    }
    
    // Use Query with FetchDescriptor
    @Query(fetchDescriptor) var workouts: [Workout]
    
    var body: some View {
        NavigationStack {
         
         //   Group {
               // if workouts.isEmpty {
//                    ContentUnavailableView {
//                        Label("No workouts yet", systemImage: "dumbbell.fill")
//                    } description: {
//                        Text("Tap the button below to get started")
//                    }
//                actions: {
//                    NavigationLink {
//                        AddWorkoutView()
//                            .toolbar(.hidden, for: .tabBar)
//                            .navigationBarBackButtonHidden(true)
//                        
//                    } label : {
//                        Text("Start Workout")
//                            .underline()
//                        
//                    }
//                }
                //}
                
//                else {
                    List {
                        Section(header: workouts.isEmpty ? Text("") : Text("Recent Workouts")) {
                            ForEach(workouts) { workout in
                                NavigationLink {
                                    EditWorkoutView(workout: workout)
                                        .toolbar(.hidden, for: .tabBar)
                                        .navigationBarBackButtonHidden(true)
                                }
                                //The UI of each List Item
                            label: { HStack(spacing: 19)
                                {
                                    
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
                                    
                                    //i know this wont be nil but still best to provide a default anyway
                                    VStack(spacing: 0) {
                                        Text(workout.endTime.formatted(.dateTime.weekday()))
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
                                        Text(workout.endTime.formatted(.dateTime.day(.twoDigits)))
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
                                    
                                    
                                    //chatgpt why is my workout.name and exercises text not aligned?
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(workout.name)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 18, weight: .semibold, design: .default))
                                        
                                        //The Stats
                                        if let exercises =  workout.exercises {
                                            Text("\(exercises.count)x Exercises")
                                                .font(.system(size: 13))
                                        }
                                        
                                    } }
                            }
                                
                                
                            }
                            
                        }
                        
                    } //end list
                    .overlay {
                        if workouts.isEmpty {
                            ContentUnavailableView {
                                Label("No workouts yet", systemImage: "dumbbell.fill")
                            } description: {
                                Text("Tap the button below to get started")
                            }
                        actions: {
                                NavigationLink {
                                    AddWorkoutView()
                                        .toolbar(.hidden, for: .tabBar)
                                        .navigationBarBackButtonHidden(true)
                                    
                                } label : {
                                    Text("Start Workout")
                                        .underline()
                                        }
                             }
                           }
                        
                        }
                    
                    
                //}
          //  } //end group
            
           // WorkoutListView(sort: sortOrder, selectedDate: selectedDate, showDuplicateButton: showDuplicateButton)
            .navigationTitle("\(selectedDate,  format: .dateTime.month())")
            .background(Color.gray)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(showDuplicateButton ? "Done" : "Repeat") {
                        showDuplicateButton.toggle()
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        Text(("\(selectedDate,  format: .dateTime.month())"))
                            .fontWeight(.bold)
                            .font(. system(size: 18))
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink() {
                        AddWorkoutView()
                            .toolbar(.hidden, for: .tabBar)
                            .navigationBarBackButtonHidden(true)
                        
                    } label : {
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)      // << here !!
                            .frame(width: 17, height: 17)
                            .rotationEffect(.degrees(isRotating ?  0 : -37))
                            .padding(5)
                        
                    }
                }
                
            }
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatCount(3)
                
                withAnimation(repeated) {
                    isRotating.toggle()
                }
            }
            
            
            
        }
        
        
        
    }
}



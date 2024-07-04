//
//  ContentView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    
    //@State private var pathStore = PathStore()
    
    //@EnvironmentObject var router: Router
    
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
    @State private var isRotating = false
    
    
    
    
    var body: some View {
        NavigationStack() {
            
            if workouts.isEmpty {
                ContentUnavailableView {
                    Label("No workouts yet", systemImage: "dumbbell.fill")
                } description: {
                    Text("Tap the button below to get started")
                } 
            actions: {
                //chatGpt if i uncomment this code it causes an Error
               // let workout = Workout(id: UUID())
                    NavigationLink {
                       
                        
//                        EditWorkoutView(workout: workout)
//                            .navigationBarBackButtonHidden(true)
                        
                        AddWorkoutView()
                        
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
                                              .toolbar(.hidden, for: .tabBar)
                                               .navigationBarBackButtonHidden(true)
                            }
                                //The UI of each List Item
                        label: { HStack(spacing: 19) {
                            
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
                    
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(showDuplicateButton ? "Done" : "Repeat") {
                            showDuplicateButton.toggle()
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text(Date.now, format: .dateTime.day().month().year())
                            .fontWeight(.semibold)
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
}

#Preview {
    ContentView()
}

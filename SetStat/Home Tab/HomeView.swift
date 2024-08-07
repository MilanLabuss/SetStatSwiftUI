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
    
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var modelContext
    @State private var showDuplicateButton = false
    @State private var showStatsButton = false
    @State private var isRotating = false
    @State private var selectedDate: Date = Date.now
    
    @State private var sortOrder = SortDescriptor(\Workout.endTime, order: .reverse)
    @Query var workouts: [Workout]
      
    var body: some View {
        NavigationStack(path: $router.path) {
            WorkoutListView(sort: sortOrder, selectedDate: selectedDate, showDuplicateButton: showDuplicateButton, showStatsButton: showStatsButton)
                .navigationTitle("\(selectedDate,  format: .dateTime.month())")
                .navigationDestination(for: Workout.self) { workout in
                    EditWorkoutView(workout: workout)
                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden(true)
            }

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
                                .font(.headline)
                                .underline()
                                }
                     }
                   }
            }
            .background(Color.gray)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 10) {
                      // Button(showDuplicateButton ? "Done" : "Repeat")
                        //Show copy Buttons
                        Button {
                            
                            showDuplicateButton.toggle()
                            if(showStatsButton == true) {
                                showStatsButton.toggle()
                            }
                        } label: {
                            if(showDuplicateButton == false) {
                                Image(systemName: "plus.rectangle.on.rectangle")
                            }
                            else {
                                Text("Done")
                                    .underline()
                            }
                            
                        }
                        //Show stats button
                        Button {
                            showStatsButton.toggle()
                            if(showDuplicateButton == true) {
                                showDuplicateButton.toggle()
                            }
                        } label: {
                            if(showStatsButton == false) {
                                Image(systemName: "chart.bar.xaxis.ascending")
                            }
                            else {
                                Text("Done")
                                    .underline()
                            }
                       
                        }
                        
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Button {
                            //removing one month to the date to toggle back
                            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                        }
                        Text(("\(selectedDate,  format: .dateTime.month())"))
                            .fontWeight(.bold)
                            .font(. system(size: 18))
                        Button {
                            //adding one month to the date
                            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                        }
                        //
                        .disabled(selectedDate > Date.now)
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
                                .frame(width: 16, height: 16)
                                .rotationEffect(.degrees(isRotating ?  -37 : 0))
                                .padding(5)
                            
                        }
                    
                    
                }
                
            }
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1)
                let repeated = baseAnimation.repeatCount(1)
                
                withAnimation(repeated) {
                    isRotating = true
                }
            }
            .onDisappear {
                isRotating = false
            }
            
            
            
        }  //END navigationStack
    
    }

}



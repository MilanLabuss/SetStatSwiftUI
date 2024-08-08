////
////  WorkoutListView.swift
////  SetStat
////
////  Created by Milan Labus on 05/07/2024.
////

import SwiftUI
import SwiftData


//Will display a list of all workouts for the month of the passed down selectedDate
struct WorkoutListView: View {
    
    
    @Environment(\.modelContext) var modelContext
    
    @Query(animation: .easeIn) var workouts: [Workout]
    var selectedDate : Date
    
    var showDuplicateButton: Bool
    var showStatsButton: Bool
    
    @State var selectedWorkout: Workout?
    
    //initialiser will filter the query to apply a predicate showing only workouts from this month
    init(sort: SortDescriptor<Workout>, selectedDate: Date, showDuplicateButton: Bool, showStatsButton: Bool) {
        self.showDuplicateButton = showDuplicateButton
        self.showStatsButton = showStatsButton
        self.selectedDate = selectedDate
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        var components = DateComponents()
        components.month = 1
        components.second = -1
        let endOfMonth = calendar.date(byAdding: components, to: startOfMonth)!
        
        //Predicate for getting only the Workouts of the month of the SelectedDate
        let predicate = #Predicate<Workout> {
            $0.endTime >= startOfMonth && $0.endTime < endOfMonth
        }
        
        _workouts = Query(filter: predicate,sort: [sort])
    }
    
    
    
    
    var body: some View {
        
        List {
            Section(header: workouts.isEmpty ? Text("") : Text("Workouts")) {
                ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        HStack(spacing: 19) {
                            
                            if showDuplicateButton {
                                Button {
                                    //the workout copy method uses the exercises copy method to copy all exercises which itself does the same for its sets
                                    let newWorkout = workout.copy()
                                    withAnimation(.spring()){
                                        modelContext.insert(newWorkout)
                                    }
                                    
                                }
                            label: {
                                Image(systemName: "plus.rectangle.on.rectangle")
                            }
                            .buttonStyle(.borderless)
                            }
                            
                            
                            if showStatsButton {
                                Button {
                                  selectedWorkout = workout
                                }
                            label: {
                                Image(systemName: "chart.bar.xaxis")
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
                                
                            }
                        }
                    } //End NavLink
                    
                    
                }
                .onDelete(perform: delete)
                
            }
            
        }
//        .popover(item: $selectedWorkout) { workout in  // <-- here
//            WorkoutDetailView(workout: workout)
//            }
        .fullScreenCover(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout)
        }
        //.animation(.spring(duration: 3), value: workouts)
//        .sheet(isPresented: $selectedWorkout) {
//            WorkoutDetailView(workout: workout)
//                .presentationDetents([.medium, .large])
//                .presentationContentInteraction(.scrolls)
//        }
        
    }
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let workout = workouts[offset]
            modelContext.delete(workout)
        }
    }
}


////
////  WorkoutListView.swift
////  SetStat
////
////  Created by Milan Labus on 05/07/2024.
////
//
//import SwiftUI
//import SwiftData
//
//struct WorkoutListView: View {
//    
//    
//    @Environment(\.modelContext) var modelContext
//    
//    @Query var workouts: [Workout]
//    var selectedDate : Date
//    
//    var showDuplicateButton: Bool
//        
//    init(sort: SortDescriptor<Workout>, selectedDate: Date, showDuplicateButton: Bool) {
//        self.showDuplicateButton = showDuplicateButton
//        self.selectedDate = selectedDate
//        let calendar = Calendar.current
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
//        var components = DateComponents()
//        components.month = 1
//        components.second = -1
//        let endOfMonth = calendar.date(byAdding: components, to: startOfMonth)!
//        
//        let predicate = #Predicate<Workout> {
//            $0.endTime >= startOfMonth && $0.endTime < endOfMonth
//        }
//        
//        _workouts = Query(filter: predicate,sort: [sort])
//    }
//    
//    
//    var body: some View {
//        
//        List {
//            Section(header: Text("Recent Workouts")) {
//                ForEach(workouts) { workout in
//                    NavigationLink {
//                        EditWorkoutView(workout: workout)
//                            .toolbar(.hidden, for: .tabBar)
//                            .navigationBarBackButtonHidden(true)
//                    }
//                    //The UI of each List Item
//                label: { HStack(spacing: 19)
//                    {
//                        
//                        if showDuplicateButton {
//                            Button {
//                                //the workout copy method uses the exercises copy method to copy all exercises which itself does the same for its sets
//                                let newWorkout = workout.copy()
//                                modelContext.insert(newWorkout)
//                                //showDuplicateButton.toggle()
//                                
//                            }
//                        label: {
//                            Image(systemName: "plus.rectangle.on.rectangle")
//                        }
//                        .buttonStyle(.borderless)
//                        }
//                        
//                        //i know this wont be nil but still best to provide a default anyway
//                        VStack(spacing: 0) {
//                            Text(workout.endTime.formatted(.dateTime.weekday()))
//                                .frame(maxWidth: .infinity)
//                                .foregroundStyle(.white)
//                                .font(.system(size: 14))
//                                .padding([.top, .leading, .trailing], 5)
//                                .padding([.bottom], 2)
//                                .background(Color(red: 70/255, green: 130/255, blue: 180/255))
//                                .clipShape(
//                                    .rect(
//                                        topLeadingRadius: 5,
//                                        bottomLeadingRadius: 0,
//                                        bottomTrailingRadius: 0,
//                                        topTrailingRadius: 5
//                                    )
//                                )
//                            Text(workout.endTime.formatted(.dateTime.day(.twoDigits)))
//                                .frame(maxWidth: .infinity)
//                                .font(.system(size: 16))
//                                .padding([.top], 2)
//                                .padding([.bottom], 5)
//                        }
//                        .frame(width: 42)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black.opacity(0.4), lineWidth: 1)
//                        )
//                        
//                        
//                        //chatgpt why is my workout.name and exercises text not aligned?
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(workout.name)
//                                .fontWeight(.semibold)
//                                .font(.system(size: 18, weight: .semibold, design: .default))
//                            
//                            //The Stats
//                            if let exercises =  workout.exercises {
//                                Text("\(exercises.count)x Exercises")
//                                    .font(.system(size: 13))
//                            }
//                            
//                        }
//                    }
//                }
//                    
//                    
//                }
//                
//            }
//            
//        } //end list
//        
//        
//        
//        
//    }
//}
//

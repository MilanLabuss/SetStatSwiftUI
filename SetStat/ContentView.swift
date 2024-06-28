//
//  ContentView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {

    static var fetchDescriptor: FetchDescriptor<Workout> {
            var descriptor = FetchDescriptor<Workout>(
                sortBy: [
                    
                    SortDescriptor(\.endTime, order: .reverse)
                ]
            )
            descriptor.fetchLimit = 5
            return descriptor
        }
    
    @Query(fetchDescriptor) private var workouts: [Workout]
   
    @Environment(\.modelContext) var modelContext
    @State private var selection: Workout?
    

    
    
    
    var body: some View {
        NavigationStack {
            //Text(workouts.isEmpty ? "" : "Recent Workouts")
            List(selection: $selection) {
                Section(header: Text("Recent Workouts")) {
                    ForEach(workouts) { workout in
                        NavigationLink {
                            EditWorkoutView(workout: workout)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            //The Date and Exercise name
                            HStack(spacing: 19) {
                                if let endTime = workout.endTime {
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
                                    .frame(width: 38)
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
                EditButton()
                Spacer()
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

#Preview {
    ContentView()
}

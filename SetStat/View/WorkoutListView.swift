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
    @Query var exercises: [Exercise]
    @Query var sets: [MySet]

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
            //chatgpt the problem isnt ehre i can see the new workouts when they get added
            Section(header: workouts.isEmpty ? Text("") : Text("Workouts")) {
                ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        HStack(spacing: 19) {
                            
                            if showDuplicateButton {
                                Button {
                                    //the workout copy method uses the exercises copy method to copy all exercises which itself does the same for its sets
//                                    let newWorkout = workout.copy()
//                            
//                                    modelContext.insert(newWorkout)
                                    
                                    //chatgpt now that you see my SwiftData Relationships explain why this crashes my code
                                    duplicateWorkout(workout: workout)
    
                                    
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
                                
                                Text("\(countExercises(for: workout))x Exercises")
                                                                    .font(.system(size: 13))

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
        //chatgpt this detail screen takes a workout and shows all exercises associated with that workout and it does but only once i refresh the app
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
    //will count how many exercises a workout has by filtering the exercises query by workout
    private func countExercises(for workout: Workout) -> Int {
        // Filter the exercises to get those related to the current workout
        let filteredExercises = exercises.filter { $0.workout == workout }
        return filteredExercises.count
    }
    
    
//    func duplicateWorkout(workout: Workout) {
//        //chatgpt use the exercises query to find all exercises whos workout matches the passed down workout and put it into a Closure
//        
//        let newWorkout = Workout(id: UUID(), name: workout.name, startTime: Date.now, endTime: Date.now)
//        modelContext.insert(newWorkout)
//        if let exercises = workout.exercises {
//         
//            for exercise in exercises {
//                let newExercise = Exercise(
//                    id: UUID(),
//                    exerciseName: exercise.exerciseName,
//                    date: Date.now,
//                    workout: newWorkout
//                )
//                 modelContext.insert(newExercise)
//                
//                if let sets = exercise.sets {
//                   // var newSets: [MySet] = []
//                    
//                    for set in sets {
//               
//                        let newSet = MySet(
//                            id: UUID(),
//                           
//                            weight: set.weight,
//                            reps: set.reps,
//                            isCompleted: false,
//                            date: Date.now,
//                            exercise: newExercise
//                        )
//                        
//                       modelContext.insert(newSet)
//                       // newExercise.sets?.append(newSet)
//                    }
// 
//                }
// 
//            }
//           
//            
//        }
//    }
//    
    
    
    func duplicateWorkout(workout: Workout) {
        // Create a new Workout instance
        let newWorkout = Workout(id: UUID(), name: workout.name, startTime: Date.now, endTime: Date.now)
        modelContext.insert(newWorkout)

        // Fetch the exercises related to the workout using the `exercises` query
        let relatedExercises = exercises.filter { $0.workout == workout }

        for exercise in relatedExercises {
            // Create a new Exercise instance for the duplicated workout
            let newExercise = Exercise(
                id: UUID(),
                name: exercise.name,
                date: Date.now,
                workout: newWorkout
            )
            modelContext.insert(newExercise)

            // Fetch the sets related to the current exercise
            let relatedSets = sets.filter { $0.exercise == exercise }

            for set in relatedSets {
                // Create a new MySet instance for the duplicated exercise
                let newSet = MySet(
                    id: UUID(),
                    weight: set.weight,
                    reps: set.reps,
                    isCompleted: false,
                    date: Date.now,
                    exercise: newExercise
                )
                modelContext.insert(newSet)
            }
        }
    }

    
    
    
}


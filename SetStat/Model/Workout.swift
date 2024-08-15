//
//  Workout.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//
import Foundation
import SwiftData

@Model
class Workout: Identifiable {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout) //when deleting a workout you delete all exericses that happened during that workout
    var exercises: [Exercise]?
    var startTime: Date
    var endTime: Date
    
    func copy() -> Workout {
        let newWorkout = Workout(id: UUID(), name: name, startTime: startTime, endTime: endTime)
        newWorkout.name = name
        newWorkout.startTime = Date.now
        newWorkout.endTime = Date.now
        newWorkout.exercises = exercises?.map { $0.copy(newworkout: newWorkout) }
          return newWorkout
      }
    
    init(id: UUID, name: String = "", startTime: Date = Date.now, endTime: Date = Date.now) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
    }
    
    

}

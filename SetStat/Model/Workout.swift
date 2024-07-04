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
    @Relationship(deleteRule: .cascade) //when deleting a workout you delete all exericses that happened during that workout
    var exercises: [Exercise]?
    var startTime: Date
    var endTime: Date
    
    func copy() -> Workout {
        let workout = Workout(id: UUID(), name: name, startTime: startTime, endTime: endTime)
          workout.name = name
          workout.startTime = Date.now
          workout.endTime = Date.now
          workout.exercises = exercises?.map { $0.copy() }
          return workout
      }
    
    init(id: UUID, name: String = "", startTime: Date = Date.now, endTime: Date = Date.now) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
    }
    
    

}

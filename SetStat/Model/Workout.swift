//
//  Workout.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//
import Foundation
import SwiftData

@Model
class Workout {
    var id: UUID
    var name: String?
    
    @Relationship(deleteRule: .cascade) //when deleting a workout you delete all exericses that happened during that workout
    var exercises: [Exercise]?
    
    var startDate: Date?
    var endTime: Date?
    
    init(id: UUID) {
        self.id = id
    }
}

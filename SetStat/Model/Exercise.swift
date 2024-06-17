//
//  Exercise.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import Foundation
import SwiftData

@Model
class Exercise: Identifiable {
    var id: UUID
    var exerciseName: ExerciseName
    
    @Relationship(deleteRule: .cascade)
    var sets: [Set]?    //When an Exercise gets Deleted all Sets associated need to get deleted
    var date: Date
    var workout: Workout?       //it can belong to a work but it doesnt have to
    
    init(id: UUID, exerciseName: ExerciseName, date: Date) {
        self.id = id
        self.exerciseName = exerciseName
        self.date = date
    }
    
    
}

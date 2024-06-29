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
    
    func copy() -> Exercise {
        let exercise = Exercise(id: UUID(), exerciseName: exerciseName, date: Date.now)
           // exercise.sets = sets?.map { $0.copy(exercise: exercise) }
            exercise.sets = sets?.map { set in
                set.copy(exercise: exercise)    //map all of the sets by calling the sets copy method for each one in the loop using $0 syntax
            }
            return exercise
        }
    
    init(id: UUID, exerciseName: ExerciseName, date: Date) {
        self.id = id
        self.exerciseName = exerciseName
        self.date = date
    }
    
    
}

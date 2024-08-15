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
    
    @Relationship(deleteRule: .cascade, inverse: \MySet.exercise)
    var sets: [MySet]?    //When an Exercise gets Deleted all Sets associated need to get deleted

    var date: Date
    var workout: Workout
 
    func copy(newworkout: Workout) -> Exercise {
        let newExercise = Exercise(id: UUID(), exerciseName: exerciseName, date: Date.now, workout: newworkout)
        
        // Copy the related sets
//        if let existingSets = sets {
//            newExercise.sets = existingSets.map { set in
//                // Copy each set and associate it with the newExercise
//                let newSet = set.copy(newexercise: newExercise)
//                return newSet
//            }
//        }
       
            newExercise.sets = sets?.map {  $0.copy(newexercise: newExercise) }
        return newExercise
    }
    
    init(id: UUID, exerciseName: ExerciseName, date: Date, workout: Workout) {
        self.id = id
        self.exerciseName = exerciseName
        self.date = date
        self.workout = workout
    }

    
}

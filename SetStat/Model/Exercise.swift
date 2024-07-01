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
//    
//    // Codable conformance
//    enum CodingKeys: String, CodingKey {
//        case id
//        case exerciseName
//        case sets
//        case date
//        case workout
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
//        exerciseName = try container.decode(ExerciseName.self, forKey: .exerciseName)
//        sets = try container.decodeIfPresent([Set].self, forKey: .sets)
//        date = try container.decode(Date.self, forKey: .date)
//        workout = try container.decodeIfPresent(Workout.self, forKey: .workout)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(exerciseName, forKey: .exerciseName)
//        try container.encodeIfPresent(sets, forKey: .sets)
//        try container.encode(date, forKey: .date)
//        try container.encodeIfPresent(workout, forKey: .workout)
//    }
//    
    
}

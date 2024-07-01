//
//  Set.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import Foundation
import SwiftData

@Model
class Set: Identifiable {
    var id: UUID
    var weight: Int
    var reps: Int
    var isCompleted: Bool
    var exercise: Exercise
    
    //make a copy functionality so you can call this and pass it an Exercise when copying a Set
    func copy(exercise: Exercise) -> Set {
            Set(id: UUID(), weight: weight, reps: reps, isCompleted: isCompleted, exercise: exercise)
        }
    
    init(id: UUID, weight: Int, reps: Int,isCompleted: Bool, exercise: Exercise) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
        self.exercise = exercise
    }
    
    
//    // Codable conformance
//    enum CodingKeys: String, CodingKey {
//        case id
//        case weight
//        case reps
//        case isCompleted
//        case exercise
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
//        weight = try container.decode(Int.self, forKey: .weight)
//        reps = try container.decode(Int.self, forKey: .reps)
//        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
//        exercise = try container.decode(Exercise.self, forKey: .exercise)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(weight, forKey: .weight)
//        try container.encode(reps, forKey: .reps)
//        try container.encode(isCompleted, forKey: .isCompleted)
//        try container.encode(exercise, forKey: .exercise)
//    }
    
}


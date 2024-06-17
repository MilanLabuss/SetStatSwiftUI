//
//  Set.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import Foundation
import SwiftData

@Model
class Set: Identifiable{
    var id: UUID
    var weight: Int
    var reps: Int
    var isCompleted: Bool
    var exercise: Exercise
    
    init(id: UUID, weight: Int, reps: Int,isCompleted: Bool, exercise: Exercise) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
        self.exercise = exercise
    }
    
}


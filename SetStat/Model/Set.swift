//
//  Set.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import Foundation
import SwiftData

@Model
class MySet: Identifiable {
    var id: UUID
    var weight: Int
    var reps: Int
    var isCompleted: Bool
    
 
    var exercise: Exercise
    
    var date: Date
    
    //make a copy functionality so you can call this and pass it an Exercise when copying a Set
    func copy(newexercise: Exercise) -> MySet {
       let newSet =  MySet(id: UUID(), weight: weight, reps: reps, isCompleted: isCompleted,date: Date.now , exercise: newexercise)
        return newSet
        }
    
    init(
        id: UUID,
        weight: Int,
        reps: Int,
        isCompleted: Bool,
        date: Date,
        exercise: Exercise
        
    ) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
        self.date = date
        self.exercise = exercise
      
    }
    

    
}


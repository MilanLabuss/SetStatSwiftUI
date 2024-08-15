//
//  ExerciseName.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import Foundation
import SwiftData

@Model
class ExerciseName {

    var name: String
    var isFavorite: Bool
    
    init(name: String = "", isFavorite: Bool) {
        self.name = name
        self.isFavorite = isFavorite
    }

    
}

extension ExerciseName {
    
    static var defaults: [ExerciseName] {
        [
            .init(name: "Bench Press", isFavorite: false),
            .init(name: "Squat",isFavorite: false),
            .init(name: "Deadlift", isFavorite: false),
        ]
    }
    
}

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
    
    init(name: String = "") {
        self.name = name
    }

    
}

extension ExerciseName {
    
    static var defaults: [ExerciseName] {
        [
            .init(name: "Bench Press"),
            .init(name: "Squat"),
            .init(name: "Deadlift"),
        ]
    }
    
}

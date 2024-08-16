//
//  CopyWorkoutTip.swift
//  SetStat
//
//  Created by Milan Labus on 15/08/2024.
//

import Foundation
import TipKit

struct CopyWorkoutTip: Tip {
    
    static let homeVisited = Event(id: "homeVisited")
    
    @Parameter
        static var workoutAdded: Bool = false
    
    var title: Text {
            Text("Copy a Previous Workout")
            .foregroundStyle(.blue)
        }


        var message: Text? {
            Text("Repeat your Exercises and Set from a past Workout")
        }


        var image: Image? {
            Image(systemName: "plus.rectangle.on.rectangle")
                
        }
    
    var rules: [Rule] {
   
        //First rule is the homePage must have been visited at least 2 times
        #Rule(Self.homeVisited) { event in
            event.donations.count >= 2
        }
        
        //Second Rule is at least one Workout must be added to SwiftData
        #Rule(Self.$workoutAdded) {
                        // Set the conditions for when the tip displays.
                        $0 == true
                    }
        
        
    }
    
    
}

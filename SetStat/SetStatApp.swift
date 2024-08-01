//
//  SetStatApp.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData

@main
struct SetStatApp: App {
    var container: ModelContainer
    @StateObject var router = Router()
    
    
    init() {
        @AppStorage("firstTime") var firstTime = true
        do {
            let schema = Schema([Workout.self, Exercise.self, Set.self, ExerciseName.self])
            container = try ModelContainer(for: schema, configurations: [])
            
            //now to prefill with Dummy Data
            if(firstTime) {
                ExerciseName.defaults.forEach { container.mainContext.insert($0) }
                firstTime = false
            }
          
    
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
        .modelContainer(container)
               
    }
    

}

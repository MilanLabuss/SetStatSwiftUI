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
   // @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Workout.self)
       // .environmentObject(router)
        
    }
}

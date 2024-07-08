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
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
        .modelContainer(for: Workout.self)
       
        
    }
    
    //printing the location is written to so we can open it in Sqlite browser
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

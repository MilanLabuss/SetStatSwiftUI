//
//  Router.swift
//  SetStat
//
//  Created by Milan Labus on 30/06/2024.
//

import Foundation
import SwiftUI


//Just Storing the NavigationPath Globally
class Router: ObservableObject {
    @Published var path = NavigationPath()

    func reset() {
        path = NavigationPath()
    }
    
}


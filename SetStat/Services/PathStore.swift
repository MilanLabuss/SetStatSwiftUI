//
//  PathStore.swift
//  SetStat
//
//  Created by Milan Labus on 29/06/2024.
//


//Observable class to store the navigationPath to disc
import Foundation
import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            //any time the path changes the save method will get called
            save()
        }
    }

    //saving with name SavedPath in docs
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        //load the data back out from disc and put it into our path
        if let data = try? Data(contentsOf: savePath) {                                                             //1. if we can load it
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {     //2. if we can decode it
                path = NavigationPath(decoded)                                                                      //3. then we can save it to our path
                return                                                                                              //4. and exit
            }
        }

        // Still here? Start with an empty path. without we had nothing to load
        path = NavigationPath()
    }

    //called anytime the path is changed and since this class is observable the didSet changes will be instantly reflected in UI
    func save() {
        //quick check if the path conforms to codable and bail out if it doesn't
        guard let representation = path.codable else { return }

        do {
            let data = try JSONEncoder().encode(representation)     //first encode the current path representation
            try data.write(to: savePath)                            //then try to write it to disc
        } catch {
            print("Failed to save navigation data")
        }
    }
}

//
//  Workout.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//
import Foundation
import SwiftData

@Model
class Workout: Identifiable {
    var id: UUID
    var name: String?    
    @Relationship(deleteRule: .cascade) //when deleting a workout you delete all exericses that happened during that workout
    var exercises: [Exercise]?
    var startTime: Date?
    var endTime: Date?
    
    func copy() -> Workout {
          let workout = Workout(id: UUID())
          workout.name = name
          workout.startTime = Date.now
          workout.endTime = Date.now
          workout.exercises = exercises?.map { $0.copy() }
          return workout
      }
    
    init(id: UUID) {
        self.id = id
    }
    
    
//    //required for conforming to codable:
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case exercises
//        case startTime
//        case endTime
//    }
//    
//    required init(from decoder: Decoder) throws {
//         let container = try decoder.container(keyedBy: CodingKeys.self)
//         id = try container.decode(UUID.self, forKey: .id)
//         name = try container.decodeIfPresent(String.self, forKey: .name)
//         exercises = try container.decodeIfPresent([Exercise].self, forKey: .exercises)
//         startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
//         endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
//     }
//     
//     func encode(to encoder: Encoder) throws {
//         var container = encoder.container(keyedBy: CodingKeys.self)
//         try container.encode(id, forKey: .id)
//         try container.encodeIfPresent(name, forKey: .name)
//         try container.encodeIfPresent(exercises, forKey: .exercises)
//         try container.encodeIfPresent(startTime, forKey: .startTime)
//         try container.encodeIfPresent(endTime, forKey: .endTime)
//     }

}

//
//  ExerciseStatsView.swift
//  SetStat
//
//  Created by Milan Labus on 30/07/2024.
//

import SwiftUI
import SwiftData
import Charts






//Will display of the Statistics of the Passed Down ExerciseName
struct ExerciseStatsView: View {
    
    var exerciseName: ExerciseName
  
    @Query private var exercises: [Exercise]
    
    @State private var dateState: DateState = .weeks
    

  
    
    init(exerciseName: ExerciseName) {
        self.exerciseName = exerciseName
        let exercisenamesName = exerciseName.name
        _exercises = Query(filter: #Predicate<Exercise> {
            $0.exerciseName.name == exercisenamesName
        }, sort: \Exercise.date)
 
    }

    private var bestWeights: [BestWeights] {
        // Initialize an empty array to hold BestWeights
        var bestWeights: [BestWeights] = []
        
        var selectedDate = Date.now
        let calendar = Calendar.current
        // Loop to go back 12 months and find the best Set of each 30 day Period
        
        for _ in 0..<7 {

            let startPeriod = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: selectedDate))!
      
            //chatgpt explain to  me what is heppening here
            var components = DateComponents()
            
            if dateState == .weeks {
                components.day = 7
            }
            else {
                components.month = 1
            }
            components.second = -1
            let endPeriod = calendar.date(byAdding: components, to: startPeriod)!
            print("start of period: \(startPeriod)")
            print("end of period : \(endPeriod)")

            let exercisesInPeriod = exercises.filter {
                            $0.date >= startPeriod && $0.date <= endPeriod
                        }
            var bestWeightOfPeriod = 0
            
                    for exercise in exercisesInPeriod {
                 
                        if let sets = exercise.sets {
                            for set in sets {
                                if set.weight > bestWeightOfPeriod {
                                    bestWeightOfPeriod = set.weight
                                }
                            }
                        }

                    }
            
           // if(bestWeightOfPeriod != 0) {
            // Extracting year, month, and day from startPeriod
            let month = calendar.component(.month, from: startPeriod)
            let day = calendar.component(.day, from: startPeriod)
            
            if dateState == .weeks {
            
                let mondayDayString = String(format: "%02d/%02d", day, month)
                
                if(bestWeightOfPeriod != 0) {
                    bestWeights.append(BestWeights(date: mondayDayString, maxWeight: bestWeightOfPeriod))
                }
                
                //decrementing down one week(7 days)
                selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate) ?? selectedDate
                
               // let weekofyear = calendar.component(.weekOfYear, from: startPeriod)
               // selectedDate = Calendar.current.date(byAdding: , value: -1, to: selectedDate) ?? selectedDate
               // }
            } else {
                let unformattedMonth = DateFormatter().monthSymbols[month - 1]
                let formattedMonth =  String(unformattedMonth.prefix(3))
                
                if(bestWeightOfPeriod != 0) {
                    bestWeights.append(BestWeights(date: formattedMonth, maxWeight: bestWeightOfPeriod))
                }
                
                //decrementing down one month
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
            }

    
            
        }
        
        //has to be reversed because it appending into the array from oldest to newest
        return bestWeights.reversed()

    }
    

    
    var body: some View {
                VStack {
                    
                    //chatgpt make an picker here that uses my Enum and is binded to dateState
                    Picker("View Mode", selection: $dateState) {
                         ForEach(DateState.allCases, id: \.self) { mode in
                             Text(mode.rawValue).tag(mode)
                         }
                     }
                     .pickerStyle(SegmentedPickerStyle())
                     .padding()
                    
                    Chart {
                        ForEach(bestWeights) { bestWeight in
                        
                            LineMark(x: .value("Date",bestWeight.date), y: .value("MaxWeight", bestWeight.maxWeight))
                                .symbol {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 7, height: 7)
                                }
                                

                        }
                    }
    
                   .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartYAxisLabel(position: .leading, alignment: .center) {
                    }
                    .chartYAxis {
                    AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }
                    .chartXAxis {
                    AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }
                    .chartForegroundStyleScale(["Max Weight": Color.blue])
                    .chartLegend(.visible)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(5)
                }
                .navigationTitle("\(exerciseName.name)")

    }
}

//For controlling months and weeks
enum DateState: String, CaseIterable  {
    case weeks, months
}


//Struct that i will use to plot the graph
struct BestWeights: Identifiable
{
        let id = UUID()
        let date: String
        let maxWeight: Int
        

}


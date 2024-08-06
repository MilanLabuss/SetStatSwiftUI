//
//  ExerciseStatsView.swift
//  SetStat
//
//  Created by Milan Labus on 30/07/2024.
//

import SwiftUI
import SwiftData
import Charts



//For controlling months and weeks
enum DateState: String, CaseIterable  {
    case weeks, months
}


enum DataType: String, CaseIterable  {
    case MaxWeight, OneRepMax
}


//Struct that i will use to plot the graph
struct BestWeights: Identifiable
{
    let id = UUID()
    let date: Date
    let maxWeight: Int
    
    
}

//Using this to store the top weight of each bestweight in BestWeights
struct BestSetOfPeriod {
    var weight: Int
    var reps: Int
}


//Will display of the Statistics of the Passed Down ExerciseName and will be Displayed in both the Expanded View and The ExerciseStatsDetailView
struct ExerciseStatsView: View {
    
    func calculateOneRepMax(weight: Double, reps: Int) -> Double {
        return weight * (1 + 0.0333 * Double(reps))
    }
    
    //The passed down exercise we will be computing
    var exerciseName: ExerciseName
    
    //Getting all Exercises from the Exercises Array
    @Query private var exercises: [Exercise]
    
    @State private var dateState: DateState = .weeks
    
    
    init(exerciseName: ExerciseName) {
        self.exerciseName = exerciseName
        let exercisenamesName = exerciseName.name
        _exercises = Query(filter: #Predicate<Exercise> {
            $0.exerciseName.name == exercisenamesName
        }, sort: \Exercise.date)
        
    }
    
    
    @State private var dataType: DataType = DataType.MaxWeight
    
    
    //Computed value of highest weight in a given 6 week or 6 months range(for each month or week)
    private var bestWeights: [BestWeights] {
        // Initialize an empty array to hold BestWeights
        var bestWeights: [BestWeights] = []
        
        var selectedDate = Date.now
        let calendar = Calendar.current
        // Loop to go back 12 months and find the best Set of each 30 day Period
        
        for _ in 0..<8 {
            
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
            let endPeriod = calendar.date(byAdding: components, to: startPeriod)!   //the End of the week/Month
            print("start of period: \(startPeriod)")
            print("end of period : \(endPeriod)")
            
            let exercisesInPeriod = exercises.filter {
                $0.date >= startPeriod && $0.date <= endPeriod
            }
          //  var bestWeightOfPeriod = 0
            var bestSetOfPeriod = BestSetOfPeriod(weight: 0, reps: 0)
            
            for exercise in exercisesInPeriod {
                
                if let sets = exercise.sets {
                    for set in sets {
                        if set.weight > bestSetOfPeriod.weight {
                            bestSetOfPeriod.weight = set.weight
                            bestSetOfPeriod.reps = set.reps
                            //now Add reps too to make a oneRep Max
                        }
                    }
                }
                
            }
            
            
            let year = calendar.component(.year, from: startPeriod)
            let month = calendar.component(.month, from: startPeriod)
            let day = calendar.component(.day, from: startPeriod)
            let dateComponents = DateComponents(year: year, month: month, day: day)
            let date = calendar.date(from: dateComponents)!
            
            
             let isMaxWeight = (dataType == .MaxWeight)
            //chatgpt now take bestWeightOfPeriod.weight and .reps and make it into a one rep max vairable
            let oneRepMax = calculateOneRepMax(weight: Double(bestSetOfPeriod.weight), reps: bestSetOfPeriod.reps)
                        
            
            if dateState == .weeks {
                
                //ChatGpt make a bool here that is true if dataType is MaxWeight
                if(bestSetOfPeriod.weight != 0) {
                    bestWeights.append(BestWeights(date: date, maxWeight: dataType == .MaxWeight ? bestSetOfPeriod.weight : Int(oneRepMax)))
                }
                
                //decrementing down one week(7 days)
                selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate) ?? selectedDate
                
            } else {
                
                if(bestSetOfPeriod.weight != 0) {
                    bestWeights.append(BestWeights(date: date, maxWeight: dataType == .MaxWeight ? bestSetOfPeriod.weight : Int(oneRepMax)))
                }
                
                //decrementing down one month
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
            }
            
            
            
        }
        
        //has to be reversed because it appending into the array from oldest to newest
        return bestWeights.reversed()
        
    }
    
    
    //ChatGpt now make a computed Value that iterates through all bestWeights and find the highest weight
    private var topWeight: Int {
        var topweight = 0
        for bweight in bestWeights {
            if bweight.maxWeight > topweight {
                topweight = bweight.maxWeight
            }
        }
        return topweight
    }
    
    
    

    
    
    
    
    var body: some View {
        
        
        VStack(spacing: 15) {
            
            HStack {
                
             
                
                //menu for chooseing weeks or months
                Menu {
                    ForEach(DateState.allCases, id: \.self) { mode in
                        Button(action: {
                            dateState = mode
                        }) {
                            Text(mode.rawValue.capitalized)
                        }
                    }
                } label: {
                    HStack {
                        Text(dateState.rawValue.capitalized)
                            .font(.system(size: 13, weight: .semibold)) // Font size of 13 and semi-bold
                            .foregroundColor(.black) // Set text color to black
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14))  // Make the image smaller
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .frame(width: 120)
                
                Spacer()
                
                
                HStack {
                    Text(dataType == .MaxWeight ? "PR Weight: \(topWeight)" : "One Rep Max: \(topWeight)")
                        .font(.system(size: 12))  // Make the image smaller
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                //.background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
            }
            
            //                    HStack{
            //                        //chatgpt make an picker here that uses my Enum and is binded to dateState
            //                        Picker("View Mode", selection: $dateState) {
            //                             ForEach(DateState.allCases, id: \.self) { mode in
            //                                 Text(mode.rawValue).tag(mode)
            //                             }
            //                         }
            //                         .pickerStyle(SegmentedPickerStyle())
            //                         .padding()
            //                    }
            
            Chart {
                ForEach(bestWeights) { bestWeight in
                    
                    
                    if dateState == .weeks {
                        LineMark(
                            x: .value("Date",bestWeight.date, unit: .day),
                            y: .value("MaxWeight", bestWeight.maxWeight))
                        .symbol {
                            Circle()
                                .fill(.blue)
                                .frame(width: 7, height: 7)
                        }
                    }
                    else {
                        LineMark(
                            x: .value("Date",bestWeight.date, unit: .month),
                            y: .value("MaxWeight", bestWeight.maxWeight))
                        .symbol {
                            Circle()
                                .fill(.blue)
                                .frame(width: 7, height: 7)
                        }
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
                if dateState == .weeks {
                    //chatGPT how come my last label in my Chart is cut off and meanwhile in Months it is not?
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: 7)) {
                        AxisValueLabel(format: .dateTime.month(.twoDigits).day())
                        
                    }
                }
                else {
                    AxisMarks(values: .stride(by: .month)) {
                        AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                    }
                }
                
                
            }
            
            .chartForegroundStyleScale(dataType == .MaxWeight ? ["Max Weight": Color.blue] : ["One Rep Max": Color.blue] )
            .chartLegend(.visible)
            .aspectRatio(1.7, contentMode: .fit)
            //.padding()
            
            
            HStack{
                //chatgpt make an picker here that uses my Enum and is binded to dateState
                Picker("View Mode", selection: $dataType) {
                    ForEach(DataType.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            
            
            //Toggle for 1 Rep Max and MaxWeight
            //                    HStack(spacing: 25) {
            //                        ForEach(buttons, id: \.0) { value in
            //                            Button {
            //                                dataType = value.1
            //                            } label: {
            //                                Text(value.0)
            //                                    .font(.system(size: 12))
            //                                    .foregroundStyle(value.1 == dataType
            //                                        ? .gray
            //                                        : .accentColor)
            //                                    .animation(nil)
            //                            }
            //                        }
            //                    }
            //
            
            
        }
        //.navigationTitle("\(exerciseName.name)")
        
    }
}




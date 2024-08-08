//
//  NumberOfWorkoutsStat.swift
//  SetStat
//
//  Created by Milan Labus on 07/08/2024.
//

import SwiftUI
import SwiftData
import Charts


struct WorkoutsInPeriod: Identifiable {
    let id = UUID()
    let date: Date
    let numberOfWorkouts: Int
}



//this will show in the Statistics Tab and will show a chart of the number of workout a User did
struct NumberOfWorkoutsStat: View {
    
    @State private var dateState: DateState = .weeks
    
    //First we Query the Workouts DB to get all workouts
    @Query var workouts: [Workout]
    
    //then we use a computed property to get the number for each week or month
    private var numberWorkouts: [WorkoutsInPeriod] {
        var result: [WorkoutsInPeriod] = []
        let calendar = Calendar.current
        var selectedDate = Date.now
        
        // Loop to go back 8 months or weeks
        for _ in 0..<8 {
            let startPeriod: Date
            let endPeriod: Date
            
            if dateState == .weeks {
                startPeriod = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
                endPeriod = calendar.date(byAdding: .day, value: 7, to: startPeriod)!
            } else {
                startPeriod = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
                endPeriod = calendar.date(byAdding: .month, value: 1, to: startPeriod)!
            }
            
            //chatgpt use  afor loop here instead of a fitler and use it to iterate the workoutsPeriodCount
            var workoutsPeriodCount = 0
                        for workout in workouts {
                            if workout.endTime >= startPeriod && workout.endTime < endPeriod {
                                
                                workoutsPeriodCount += 1
                            }
             }
                        
            
          //  let numberOfWorkoutsInPeriod = workoutsInPeriod.count
            if workoutsPeriodCount != 0 {
                result.append(WorkoutsInPeriod(date: startPeriod, numberOfWorkouts: workoutsPeriodCount))
            }
            
            
            // Decrement the date by one week or month
            selectedDate = dateState == .weeks ?
                calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate)! :
                calendar.date(byAdding: .month, value: -1, to: selectedDate)!
        }
        
        return result.reversed()
    }
    

    
    var body: some View {
        
        
        VStack(spacing: 40) {
            
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

                }
                .frame(width: 140)
                
                Spacer()
                
                
            }

            if numberWorkouts.isEmpty {
                //chatgpt add a nice bit of padding above and below this Text
                Text("No Data")
                    .fontWeight(.semibold)
                    .padding(.vertical, 30) // Added padding
                    .padding(.horizontal, 30) // Added padding
                
            }
            else {
                
                Chart {
                    ForEach(numberWorkouts) { numberworkouts in
                        
                        
                        if dateState == .weeks {
                            LineMark(
                                x: .value("Date",numberworkouts.date, unit: .day),
                                y: .value("Total", numberworkouts.numberOfWorkouts))
                            .symbol {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 7, height: 7)
                            }

                        }
                        else {
                            LineMark(
                                x: .value("Date",numberworkouts.date, unit: .month),
                                y: .value("Total", numberworkouts.numberOfWorkouts))
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
                        
                        //                        AxisMarks(preset: .aligned, values: .stride(by: .day, count: 7)) {
                        //                            AxisValueLabel(format: .dateTime.month(.twoDigits).day())
                        
                        AxisMarks(values: .stride(by: .day, count: 7)) { value in
                            AxisValueLabel(
                                format: .dateTime.month(.twoDigits).day(),
                                anchor: value.index == 0
                                ? .topLeading
                                : value.index == value.count - 1 ? .topTrailing : .top
                            )
                        }
                        
                    //}
                        
                    }
                    else {
                        AxisMarks(values: .stride(by: .month)) {
                            AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                        }
                       
                    }
                    
                    
                }
                //.chartForegroundStyleScale(dataType == .MaxWeight ? ["Max Weight": Color.blue] : ["One Rep Max": Color.blue] )
                .chartForegroundStyleScale( ["No. of Workouts": Color.blue] )
                .chartLegend(.visible)
                .aspectRatio(1.7, contentMode: .fit)
                //.padding()
          
            }


            
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
      
        //.frame(width: 200, height: 200)
       // .padding()
//        .background(Color.white) // Background color
//        .cornerRadius(15) // Rounded corners
//        .shadow(radius: 2) // Optional: Add shadow for better effect
//        .frame(maxWidth: .infinity) // Ensure the view takes the full width available
//        .padding(.horizontal, 20) // Add padding on the sides

        
    }
}


//
//  ExerciseStatListTile.swift
//  SetStat
//
//  Created by Milan Labus on 01/08/2024.
//

import SwiftUI


//Each Tile in the StatsView
struct ExerciseStatListTile: View {
    
    @State private var showDetail = false
    
    var exerciseName: ExerciseName
    
    var body: some View {
        VStack {
            HStack {
                Text("\(exerciseName.name)")
                

                
                Spacer()
                
                Button {
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Label("Graph", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding()
                }
                
                
            }
            if showDetail {
                ExerciseStatsView(exerciseName: exerciseName)
                    .transition(.moveAndFade)
                
            }
        }
        
    
    }
}

//
//  ContentView.swift
//  SetStat
//
//  Created by Milan Labus on 12/06/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                    Label("Workout", systemImage: "dumbbell.fill")
                }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "calendar")
                    }
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.xaxis.ascending")
                    }
            }
            .toolbarBackground(Color(red: 50/255, green: 110/255, blue: 160/255).opacity(0.8), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }

    }
}

#Preview {
    ContentView()
}

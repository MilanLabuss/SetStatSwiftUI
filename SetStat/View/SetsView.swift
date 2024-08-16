//
//  SetsView.swift
//  SetStat
//
//  Created by Milan Labus on 12/08/2024.
//

import SwiftUI
import SwiftData


//this will take an exercise then query sets to find all of that exercises Sets
struct SetsView: View {
    
    let exercise: Exercise
    @Environment(\.modelContext) var modelContext
    

    @Query(sort: [SortDescriptor(\MySet.date)]) private var sets : [MySet]
    
    private var filteredSets: [MySet] {
        sets.filter { $0.exercise == exercise }
    }
    
    

    var body: some View {


        ForEach(Array(filteredSets.enumerated()), id: \.element) { index, myset in
                   VStack {
                       HStack(spacing: 10) {
                           SetEditor(currentIndex: index , myset: myset, onDelete: { deleteSet(myset) }, copySet: { copySet(myset) })
                       }
                       //chatgpt this divider only shows up when there is a third set introduced i neeed it when there are two sets too
                       if index < filteredSets.count - 1 {
                           Divider()
                       }
                       if index == 0 && filteredSets.count == 2 {
                           Divider()
                       }
                      
                   }
                   .padding(.top, 1)
                   .padding(.bottom, 3)
               }


    }
    
    private func deleteSet(_ myset: MySet) {
           modelContext.delete(myset)

       }
    
    private func copySet(_ myset: MySet) {
        let newSet = MySet(id: UUID(), weight: myset.weight ?? 0, reps: myset.reps ?? 0, isCompleted: false, date: Date.now, exercise: exercise)
        modelContext.insert(newSet)
         //  modelContext.delete(myset)

       }
    
}



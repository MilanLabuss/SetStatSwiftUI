//
//  DetailViewExercisesList.swift
//  SetStat
//
//  Created by Milan Labus on 14/08/2024.
//

import SwiftUI
import SwiftData

struct DetailViewExercisesList: View {
    var exercise: Exercise
    
    @Query var sets: [MySet]
    
    private var filteredSets: [MySet] {     //the sets that belong to the passed down exercise
        sets.filter { $0.exercise == exercise }
       }
    
    
    var body: some View {
        //chatgpt give this VStack rounded corners and a bit of elevation
        VStack(alignment: .leading, spacing: 10) {
            Text(exercise.name)
                .foregroundStyle(.black)
                .fontWeight(.semibold)
                .font(.system(size: 17))
            
            Divider()
            
           
                //Chatgpt im getting sets here whos weight and reps are 0 i cant have that
                ForEach(filteredSets) { set in
                    HStack{
                        if let setWeight = set.weight {
                            Text("\(setWeight) kg")
                                .foregroundStyle(.black)
                                .font(.system(size: 15))
                        }
                       
                        if let reps = set.reps {
                            Text("x \(reps) reps")
                                .foregroundStyle(.black)
                                .font(.system(size: 15))
                        }
                    }
                    
                }
           
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
       
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
    }
}



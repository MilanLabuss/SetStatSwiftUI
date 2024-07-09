//
//  AddExerciseView.swift
//  SetStat
//
//  Created by Milan Labus on 13/06/2024.
//

import Foundation
import SwiftUI
import SwiftData


//This will be Presented as a Sheet
struct AddExerciseView: View {
    @Environment(\.modelContext) var modelContext
    @Query var exercisesNames: [ExerciseName]
    @State private var showNameInput = false
    @State private var exerciseName = ""
    @State private var selection: ExerciseName?
    @Environment(\.dismiss) private var dismiss
    
    //The passed down Workout Object passed down from the Workout
    var workout: Workout?
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        
        
        VStack {
            HStack{
                Spacer()
                Button {
                    //more to come
                    showNameInput.toggle()
                    
                } label: {
                    showNameInput ?
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                    :
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                }
                .padding(28)
                .buttonStyle(PlainButtonStyle())
                .foregroundStyle(.blue)
            }
            if(showNameInput == true) {
                HStack{
                    TextField("Enter Exercise Name", text: $exerciseName)
                        .frame(height: 32)
                        .textFieldStyle(.roundedBorder)
                    
                    
                    
                    Button {
                        //database operation adding exerciseName to ExerciseName model
                        if (!exerciseName.isEmpty) {
                            
                            if (!exercisesNames.contains(where: { $0.name.lowercased() == exerciseName.lowercased() })) {
                                let newExeriseName = ExerciseName(name: exerciseName)
                                modelContext.insert(newExeriseName)
                                showNameInput.toggle()
                                }
                            
                           
                        }
                        
                    }label: {
                        Text("Add")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 32)
                    .frame(width: 70)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 1)
                    
                }
                .padding(.leading)
                .padding(.trailing)
                
            }
            
            List(exercisesNames,id: \.self, selection: $selection)  { exercisename in
                Text(exercisename.name)
                    
            }
        
            .animation(.easeIn(duration: 2), value: exercisesNames)
            
            //Done Button will add new exercise and dismiss the sheet
            Button {
                if(selection != nil) {
                    let newExercise = Exercise(id: UUID(),exerciseName: selection!, date: Date.now)
                    
                    modelContext.insert(newExercise)
                    
                    //Unwrapping workout to also write to workout
                    if let workout = workout {
                       withAnimation {
                           workout.exercises?.append(newExercise)
                       }
                    }
                    
                   
                  //  router.path.append(newExercise)
                    
                    dismiss()
                }
                
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            if exercisesNames.isEmpty {
                showNameInput=true
            }
        }
        
        
    }
    
}


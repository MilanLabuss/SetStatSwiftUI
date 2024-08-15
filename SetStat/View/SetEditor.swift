//
//  SetEditor.swift
//  SetStat
//
//  Created by Milan Labus on 12/08/2024.
//

import SwiftUI

//extensions to create bindings so the Textfield can directly manipulate the object
extension MySet {

    //this is turning my non optional Into a binding that takes a Int?
    var weightBinding: Binding<Int?> {
        Binding<Int?>(
            get: { self.weight },
            set: { value in
                if let value {  //unwrapping the optional that the user entered and only setting it to weight if it isnt nil
                    self.weight = value
                }
            }
        )
    }
    var repBinding: Binding<Int?> {
        Binding<Int?>(
            get: { self.reps },
            set: { value in
                if let value {
                    self.reps = value
                }
            }
        )
    }
    
}

//will contain TextFields to control a Set
struct SetEditor: View {
    
    var currentIndex: Int
    
    @Bindable var myset: MySet
    
    @State private var isShowingPopover = false

    
    var onDelete: () -> Void
    
    var copySet: () -> Void
    
    var body: some View {
        
        VStack {
            Text("\(currentIndex+1)")
                           .font(.system(size: 12))
                           .frame(width: 20, height: 20)
                           .overlay(
                               Circle()
                                   .stroke(Color.gray, lineWidth: 1) // Circular border with gray color
                           )
                         
        }
        .padding(.trailing, 5)
       
        
        VStack(alignment: .leading) {
                Text("Kg")
                .font(.system(size: 11))
                .foregroundStyle(.gray)
            
                TextField(
                    "\(myset.weight)",
                    value: myset.weightBinding, formatter: NumberFormatter()
                   )
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .frame(width: 60)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .fixedSize(horizontal: true, vertical: false)
            

               
            }
    

            
            VStack(alignment: .leading) {
                Text("Reps")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
      
                TextField(
                    "\(myset.reps)",
                    value: myset.repBinding, formatter: NumberFormatter()
                   )
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .frame(width: 60)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .fixedSize(horizontal: true, vertical: false)
                

               
            }
            
    
           Spacer()
        
        VStack {
     

            
            Menu {
                
                
                Button() {
                    copySet()
                } label: {
                    HStack {
                        Text("Copy")
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .foregroundStyle(.blue)
                        //chatgpt this sapcer isnt pushing my image next to my Text they are both on opposite side and also my image isnt coloring blue
                        
                    }
                }
                
                
                Button(role: .destructive) {
                   
                    onDelete()   //Calling the onDelete closure to delete this Set
                } label: {
                    Text("Delete")
                }
                .buttonStyle(.plain)
                
  
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray)
                    .padding()
            }
                      
            }

      
    }
    
  
}

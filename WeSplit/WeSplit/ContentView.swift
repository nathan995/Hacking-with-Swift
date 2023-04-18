//
//  ContentView.swift
//  WeSplit
//
//  Created by Nathan Getachew on 4/18/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountFocused : Bool
    let currency = Locale.current.currency?.identifier ?? "USD"
    let tipPercentages = [10,15,20,25,0]
    
    var totalPerPerson : Double {
        ( checkAmount + (checkAmount * Double(tipPercentage)/100) ) / Double(numberOfPeople+2)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section{
                    TextField("Amount",value: $checkAmount, format:
                            .currency(code: currency  ))
                    .keyboardType(.decimalPad)
                    .focused($amountFocused)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                }
                
                Section("Tip Percentage") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages,id:\.self){
                            Text($0, format: .percent)
                        }
                    }
                    
                    .pickerStyle(.segmented)
                }
                
                Section("Total per Person"){
                    Text(totalPerPerson, format: .currency(code: currency))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItem(placement: .keyboard, content: {
                    Spacer()
                    Button("Done"){
                        amountFocused = false
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

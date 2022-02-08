//
//  AddWorkoutRow.swift
//  ToDo
//
//  Created by Freddie Cassidy on 25/01/2022.
//

import SwiftUI

struct AddWorkoutRow: View {
    var workoutType: String
    var exerciseSelection: Binding<String>
    var exerciseOptions: [String]
    var setsSelection: Binding<Int>
    var repsSelection: Binding<Int>
    var weightsSelection: Binding<Double>
    
    var sets: Int
    var reps: Int
    var weights: Double
    
    var body: some View {
        if workoutType == "Cardio" {
            Picker(selection: exerciseSelection, label: Text("Select Exercise Type")) {
                ForEach(exerciseOptions, id: \.self) {
                    Text($0)
                }
            }
            VStack {
              Slider(value: weightsSelection, in: 0...120, step: 1)
                Text("\(weights, specifier: "%.0f") mins")
            }
        } else {
            Picker(selection: exerciseSelection, label: Text("Select Exercise Type")) {
                ForEach(exerciseOptions, id: \.self) {
                    Text($0)
                }
            }
            Stepper(value: setsSelection, in: 1...5) {
                Text("\(sets) sets")
            }
            Stepper(value: repsSelection, in: 1...25) {
                Text("\(reps) reps")
            }
            VStack {
              Slider(value: weightsSelection, in: 0...100, step: 0.25)
                Text("\(weights, specifier: "%.2f") kg")
            }
        }
    }
}

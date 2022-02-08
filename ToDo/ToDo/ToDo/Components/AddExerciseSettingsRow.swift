//
//  AddExerciseSettingsRow.swift
//  ToDo
//
//  Created by Freddie Cassidy on 25/01/2022.
//

import SwiftUI
import RealmSwift
import Network

struct AddExerciseSettingsRow: View {
    @EnvironmentObject var realmManager: RealmManager
    var workoutOptions: [String]
    @State var workoutGroup: String = ""
    @State var exerciseName: String = ""
    @State var creditValue: Double = 0
    
    var body: some View {
        VStack {
            TextField("Exercise Name", text: $exerciseName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .textInputAutocapitalization(.words)
            Picker(selection: $workoutGroup, label: Text("Select Exercise Type")) {
                ForEach(workoutOptions, id: \.self) {
                    Text($0)
                        .padding(.horizontal)
                }
            }
            Stepper(value: $creditValue, in: 0...5, step: 0.1) {
                Text("Credit Value: \(creditValue, specifier: "%.1f")")
            }
            Button {
                if exerciseName != "" {
                    realmManager.addExercise(exerciseName: exerciseName, workoutGroup: workoutGroup, creditValue: creditValue)
                    exerciseName = ""
                }
            } label: {
                Text("Submit Exercise")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                    .cornerRadius(30)
            }
        }
    }
}

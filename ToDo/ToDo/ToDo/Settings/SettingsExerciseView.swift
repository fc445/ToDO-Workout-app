//
//  SettingsExerciseView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 25/01/2022.
//

import SwiftUI
import RealmSwift
import Network

struct SettingsExerciseView: View {
    @EnvironmentObject var realmManager: RealmManager

    var body: some View {
        let workoutOptions  = ["Cardio", "Abs", "Legs", "Push", "Pull", "Shoulders", "Arms", "Rest", "Warm Up"]
        VStack {
            List {
                ForEach(workoutOptions, id: \.self) {workoutType in
                    Section(header: HStack{Text(workoutType).font(.title3);Spacer()}) {
                        ForEach(realmManager.exercises, id: \.id) {exercise in
                            if (exercise.workoutGroup == workoutType) {
                                ExerciseSettingsRow(exerciseName: exercise.exerciseName, creditValue: exercise.creditValue, exerciseId: exercise.id)
                                    .environmentObject(realmManager)
                            }
                        }
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Add Exercise")) {
                AddExerciseSettingsRow(workoutOptions: workoutOptions)
                    .environmentObject(realmManager)
            }
        }
    }
}

struct SettingsExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsExerciseView()
    }
}

//
//  WorkoutRow.swift
//  ToDo
//
//  Created by Freddie Cassidy on 22/01/2022.
//

import SwiftUI

struct WorkoutRow: View {
    static let formatter1: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      return formatter
    }()
    
    @State var isExpanded = false
    
    var workoutType: String
    var workoutDate: Date
    var exercises: String
    var sets: String
    var reps: String
    var weights: String
    
    var body: some View {
        let exercisesArray = exercises.components(separatedBy: ",")
        let setsArray = exercises.components(separatedBy: ",")
        let repsArray = exercises.components(separatedBy: ",")
        let weightsArray = exercises.components(separatedBy: ",")
        DisclosureGroup(isExpanded: $isExpanded) {
            if workoutType == "Cardio" {
                HStack {
                    Spacer()
                    Text("Duration (mins)")
                }
            } else {
                HStack {
                    Spacer()
                    Text("Sets|Reps|Weight")
                }
            }
            ForEach(0...(exercisesArray.count-1), id: \.self) {i in
                // If cardio then the exercises are duration based, held in weights
                if workoutType == "Cardio" {
                    HStack {
                        Text(exercisesArray[i])
                        Spacer()
                        Text(weightsArray[i])
                    }
                } else {
                    if exercisesArray[i] != "" {
                        HStack {
                            Text(exercisesArray[i])
                            Spacer()
                            Text("\(setsArray[i])|\(repsArray[i])|\(weightsArray[i])")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(workoutType)
                
                Spacer()
                
                Text(WorkoutRow.formatter1.string(from: workoutDate))
            }
        }
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow(workoutType: "Pull", workoutDate: Date(), exercises: "Lifts,Not Lifts", sets: "1,2", reps: "5,6", weights: "40,1")
    }
}

//
//  AddWorkoutView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 22/01/2022.
//

import SwiftUI

extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

func NumberArrayToString (array: Array<Int>) -> String {
    var newArray: [String] = []
    for i in array {
        newArray.append(String(i))
    }
    return newArray.joined(separator: ",")
}
func NumberArrayToString (array: Array<Double>) -> String {
    var newArray: [String] = []
    for i in array {
        newArray.append(String(i))
    }
    return newArray.joined(separator: ",")
}
func getExerciseOptions (realmManager: RealmManager, workout: String) -> [String] {
    var exercises: [String] = []
    for exercise in realmManager.exercises {
        if (exercise.workoutGroup == workout) {
            exercises.append(exercise.exerciseName)
        }
    }
    return exercises
}
func daysFromToday (date: Date) -> Int {
  let interval = Date() - date
  return interval.day!
}

struct AddWorkoutView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var isExpanded = false
    @State private var workoutType: String = ""
    @State private var workoutDateToday = true
    @State private var workoutDate = Date()
    @State private var exercisesArray: Array<String> = Array(repeating: "", count: 10)
    @State private var setsArray: Array<Int> = Array(repeating: 0, count: 10)
    @State private var repsArray: Array<Int> = Array(repeating: 0, count: 10)
    @State private var weightsArray: Array<Double> = Array(repeating: 0, count: 10)
    @State private var nExercises: Int = 0
    @Environment(\.dismiss) var dismiss
    
    func getLatestWorkout (workoutType: String) -> Date {
        var date = Date(timeIntervalSinceReferenceDate:0)
        for workout in realmManager.workouts {
            if (workout.workoutType == workoutType) {
                if (workout.workoutDate > date) {
                    date = workout.workoutDate
                }
            }
        }
      return date
    }
    func returnWorkoutOptions () -> [String] {
        var finalList = [String]()
        
        let minimumTimes = [
          "Cardio":
            ["Cardio": 3, "Abs": 0, "Legs": 1, "Push": 0, "Pull": 0, "Shoulders": 0, "Arms": 0, "Rest": 0, "Warm Up": -1],
          "Abs":
            ["Cardio": 0, "Abs": 1, "Legs": 0, "Push": 0, "Pull": 0, "Shoulders": 0, "Arms": 0, "Rest": 0, "Warm Up": -1],
          "Legs":
            ["Cardio": 1, "Abs": 0, "Legs": 4, "Push": 1, "Pull": 1, "Shoulders": 1, "Arms": 1, "Rest": 0, "Warm Up": -1],
          "Push":
            ["Cardio": 0, "Abs": 0, "Legs": 0, "Push": 3, "Pull": 1, "Shoulders": 2, "Arms": 2, "Rest": 0, "Warm Up": -1],
          "Pull":
            ["Cardio": 0, "Abs": 0, "Legs": 0, "Push": 1, "Pull": 3, "Shoulders": 2, "Arms": 2, "Rest": 0, "Warm Up": -1],
          "Shoulders":
            ["Cardio": 0, "Abs": 0, "Legs": 0, "Push": 2, "Pull": 2, "Shoulders": 3, "Arms": 0, "Rest": 0, "Warm Up": -1],
          "Arms":
            ["Cardio": 0, "Abs": 0, "Legs": 0, "Push": 2, "Pull": 2, "Shoulders": 0, "Arms": 3, "Rest": 0, "Warm Up": -1],
          "Rest":
            ["Cardio": 0, "Abs": 0, "Legs": 0, "Push": 0, "Pull": 0, "Shoulders": 0, "Arms": 0, "Rest": 4, "Warm Up": -1],
          "Warm Up":
            ["Cardio": -1, "Abs": -1, "Legs": -1, "Push": -1, "Pull": -1, "Shoulders": -1, "Arms": -1, "Rest": -1, "Warm Up": -1]]
        
        let workoutOptions  = ["Cardio", "Abs", "Legs", "Push", "Pull", "Shoulders", "Arms", "Rest", "Warm Up"]

        for workoutTypeA in workoutOptions {
            var count = 0
            let minTimes = minimumTimes[workoutTypeA]
            for workoutTypeB in workoutOptions {
                let minTime = minTimes![workoutTypeB]
                let mostRecentWorkoutB = getLatestWorkout(workoutType: workoutTypeB)
                if (daysFromToday(date: mostRecentWorkoutB) > minTime!) {
                    count += 1
                }
            }
            if (count == workoutOptions.count) {
                finalList.append(workoutTypeA)
            }
        }
        if (finalList.isEmpty) {
            finalList = ["Empty"]
        }
        return finalList
    }
    func getCreditValue (realmManager: RealmManager, workoutType: String, exerciseArray: [String], setsArray: [Int]) -> Double {
        var creditValue: Double = 0
        let multiplier = realmManager.rewards[0].creditsEarnedPerExercise
        
        for (i, exercise) in exerciseArray.enumerated() {
            for listedExercise in realmManager.exercises {
                if (listedExercise.exerciseName == exercise) {
                    if workoutType == "Cardio" {
                        creditValue += Double(multiplier) * listedExercise.creditValue * Double(Int(weightsArray[i]).quotientAndRemainder(dividingBy: 10).quotient)
                    } else {
                        creditValue += Double(multiplier) * listedExercise.creditValue * Double(setsArray[i])
                    }
                }
            }
        }
        return creditValue
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Record a New Workout")
                    .font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Select workout to add
                Form {
                    Section(header: Text("Workout Type")) {
                        Picker(selection: $workoutType, label: Text("Select Workout Type")) {
                            ForEach(returnWorkoutOptions(), id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    Section(header: Text("Exercises")) {
                        ForEach(0...9, id: \.self) {i in
                            if (i < nExercises) {
                                DisclosureGroup(isExpanded: $isExpanded) {
                                    AddWorkoutRow(workoutType: workoutType, exerciseSelection: $exercisesArray[i], exerciseOptions: getExerciseOptions(realmManager: realmManager, workout: workoutType), setsSelection: $setsArray[i], repsSelection: $repsArray[i], weightsSelection: $weightsArray[i], sets: setsArray[i], reps: repsArray[i], weights: weightsArray[i])
                                } label: {
                                    Text("Exercise: " + String(i+1))
                                }
                            }
                        }
                        
                        Button {
                            nExercises += 1
                        } label: {
                            Text("Add Exercise")
                        }
                    }
                    
                    //Workout Date
                    Section {
                        Toggle("Is the Workout Today?", isOn: $workoutDateToday)
                        if !workoutDateToday {
                            DatePicker("Enter Date of Workout: ", selection: $workoutDate, displayedComponents: [.date])
                        }
                    }
                }
                
                // Add Button
                Group {
                    Button {
                        if workoutType != "" {
                            realmManager.addWorkout(workoutType: workoutType, workoutDate: workoutDate, exercises: exercisesArray.joined(separator: ","), sets: NumberArrayToString(array: setsArray), reps: NumberArrayToString(array: repsArray), weights: NumberArrayToString(array: weightsArray))
                            realmManager.updateReward(valueToAdd: getCreditValue(realmManager: realmManager, workoutType: workoutType, exerciseArray: exercisesArray, setsArray: setsArray))
                        }
                        dismiss()
                    } label: {
                        Text("Record Workout")
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal)
                            .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                            .cornerRadius(30)
                    }
                }
            }
            .padding(.top, 40)
            .padding(.horizontal)
            .background(Color(hue: 0.505, saturation: 0.902, brightness: 0.805))
        }
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView()
    }
}

//
//  WorkoutsView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 22/01/2022.
//

import SwiftUI
import Network
import RealmSwift

struct WorkoutsView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showAddWorkoutView = false
    
    func getCreditValue (id: ObjectId) -> Double {
        var creditValue: Double = 0
        let multiplier = realmManager.rewards[0].creditsEarnedPerExercise
        let workout = realmManager.localRealm!.objects(Workout.self).filter(NSPredicate(format: "id == %@", id))[0]
        let workoutType = workout.workoutType
        let exerciseArray = workout.exercises.split(separator: ",")
        let setsArray = workout.sets.split(separator: ",")
        let weightsArray = workout.weights.split(separator: ",")
        
        for (i, exercise) in exerciseArray.enumerated() {
            for listedExercise in realmManager.exercises {
                if (listedExercise.exerciseName == exercise) {
                    if workoutType == "Cardio" {
                        creditValue += Double(multiplier) * listedExercise.creditValue * Double(Int(Double(weightsArray[i])!).quotientAndRemainder(dividingBy: 10).quotient)
                    } else {
                        creditValue += Double(multiplier) * listedExercise.creditValue * Double(setsArray[i])!
                    }
                }
            }
        }
        return creditValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Page Title
                Group {
                    Text("My Workouts")
                        .font(.title3).bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                
                // Present Workouts
                Group {
                    List {
                        ForEach(realmManager.workouts, id: \.id) {
                            workout in
                            if !workout.isInvalidated {
                                WorkoutRow(workoutType: workout.workoutType, workoutDate: workout.workoutDate, exercises: workout.exercises, sets: workout.sets, reps: workout.reps, weights: workout.weights)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            realmManager.updateReward(valueToAdd: -getCreditValue(id: workout.id))
                                            realmManager.deleteWorkout(id: workout.id)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    //.swipeActions(edge: .leading) {
                                    //    Button {
                                    //
                                    //    } label: {
                                    //        Label("Complete", systemImage: "checkmark").foregroundColor(.white)
                                    //    }.tint(.green)
                                    //}
                            }
                        }
                    }
                    .onAppear {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hue: 0.505, saturation: 0.902, brightness: 0.805))
        
            // Add Workout View Button
            Group {
                SmallAddButton()
                    .padding()
                    .onTapGesture {
                        showAddWorkoutView.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .sheet(isPresented: $showAddWorkoutView) {
            AddWorkoutView()
                .environmentObject(realmManager)
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}

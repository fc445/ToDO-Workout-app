//
//  RealmManager.swift
//  ToDo
//
//  Created by Freddie Cassidy on 11/01/2022.
//

import Foundation
import RealmSwift
import SwiftUI

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var tasks: [Task] = []
    @Published private(set) var subTasks: [SubTask] = []
    @Published private(set) var workouts: [Workout] = []
    @Published private(set) var exercises: [Exercise] = []
    @Published private(set) var rewards: [Reward] = []
    @Published private(set) var rewardItems: [RewardItem] = []
    
    init() {
        openRealm()
        getTasks()
        getWorkouts()
        getExercises()
        getRewards()
        getRewardItems()
    }
    
    func openRealm() {
        do{
            let config = Realm.Configuration(schemaVersion: 17)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
            
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addWorkout(workoutType: String, workoutDate: Date, exercises: String, sets: String, reps: String, weights: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newWorkout = Workout(value: ["workoutType": workoutType, "workoutDate": workoutDate, "exercises": exercises, "sets": sets, "reps": reps, "weights": weights])
                    localRealm.add(newWorkout)
                    getWorkouts()
                    print("Added new workout to Realm: \(newWorkout)")
                }
            } catch {
                print("Error adding workout to Realm: \(error)")
            }
        }
    }
    
    func addTask(taskTitle: String, dueDate: Date, expectedDuration: Double) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newTask = Task(value: ["title": taskTitle, "completed": false, "progress": 0, "priority": 1, "attachedNotes": ",,,,,,,,,", "dueDate": dueDate, "expectedDuration": expectedDuration])
                    localRealm.add(newTask)
                    getTasks()
                    print("Added new task to Realm: \(newTask)")
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    func addReward() {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newReward = Reward(value: ["creditValue": 0, "creditsEarnedPerExercise": 0, "creditsEarnedPerHourWork": 0])
                    localRealm.add(newReward)
                    getRewards()
                    print("Added new reward to Realm: \(newReward)")
                }
            } catch {
                print("Error adding reward to Realm: \(error)")
            }
        }
    }
    
    func addRewardItem(rewardItemName: String, creditValue: Double) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newRewardItem = RewardItem(value: ["rewardItemName": rewardItemName, "creditValue": creditValue])
                    localRealm.add(newRewardItem)
                    getRewardItems()
                    print("Added new reward item to Realm: \(newRewardItem)")
                }
            } catch {
                print("Error adding reward item to Realm: \(error)")
            }
        }
    }
    
    func addSubTask(taskTitle: String, parentId: ObjectId, expectedDuration: Double) {
        if let localRealm = localRealm {
            do {
                // Set Values for required externals
                let otherSubTasks = localRealm.objects(SubTask.self).filter(NSPredicate(format: "parentId == %@", parentId))
                let parentTask = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", parentId))[0]
                let reward = localRealm.objects(Reward.self)[0]
                
                try localRealm.write {
                    let newSubTask = SubTask(value: ["title": taskTitle, "completed": false, "progress": 0, "priority": 1, "notes": ",,,,,,,,,,", "dueDate": Date(), "parentId": parentId, "expectedDuration": expectedDuration])
                    localRealm.add(newSubTask)
                    getSubTasks()
                    print("Added new subTask to Realm: \(newSubTask), parent: \(parentId)")
                }
                if otherSubTasks.isEmpty {
                    updateReward(valueToAdd: -Double(reward.creditsEarnedPerHourWork) * parentTask.progress * parentTask.expectedDuration)
                }
            } catch {
                print("Error adding task to Realm: \(error)")
            }
        }
    }
    
    func addExercise(exerciseName: String, workoutGroup: String, creditValue: Double) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newExercise = Exercise(value: ["exerciseName": exerciseName, "workoutGroup": workoutGroup, "creditValue": creditValue])
                    localRealm.add(newExercise)
                    getExercises()
                    print("Added new exercise to Realm: \(newExercise)")
                }
            } catch {
                print("Error adding exercise to Realm: \(error)")
            }
        }
    }
    
    func getWorkouts() {
        if let localRealm = localRealm {
            let allWorkouts = localRealm.objects(Workout.self)
            workouts = []
            allWorkouts.forEach { workout in
                workouts.append(workout)
            }
        }
    }
    
    func getRewards() {
        if let localRealm = localRealm {
            let allRewards = localRealm.objects(Reward.self)
            rewards = []
            allRewards.forEach { reward in
                rewards.append(reward)
            }
            if rewards.isEmpty {
                do {
                    try localRealm.write {
                        let newReward = Reward(value: ["creditValue": 0, "creditsEarnedPerExercise": 0, "creditsEarnedPerHourWork": 0])
                        localRealm.add(newReward)
                        print("Added new reward to Realm: \(newReward)")
                    }
                } catch {
                    print("Error adding reward to Realm: \(error)")
                }
            }
        }
    }
    
    func getTasks() {
        if let localRealm = localRealm {
            let allTasks = localRealm.objects(Task.self).sorted(byKeyPath: "dueDate")
            tasks = []
            allTasks.forEach { task in
                tasks.append(task)
            }
        }
        getSubTasks()
    }
    
    func getRewardItems() {
        if let localRealm = localRealm {
            let allRewardItems = localRealm.objects(RewardItem.self).sorted(byKeyPath: "rewardItemName")
            rewardItems = []
            allRewardItems.forEach { rewardItem in
                rewardItems.append(rewardItem)
            }
        }
        getSubTasks()
    }
    
    func getSubTasks() {
        if let localRealm = localRealm {
            let allSubTasks = localRealm.objects(SubTask.self)
            subTasks = []
            allSubTasks.forEach { subTask in
                subTasks.append(subTask)
            }
        }
    }
    
    func getExercises() {
        if let localRealm = localRealm {
            let allExercises = localRealm.objects(Exercise.self).sorted(byKeyPath: "exerciseName")
            exercises = []
            allExercises.forEach { exercise in
                exercises.append(exercise)
            }
        }
    }
    
    func setSubTaskDueDates(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let task = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))[0]
                getSubTasks()
                let subTasks = localRealm.objects(SubTask.self).filter(NSPredicate(format: "parentId == %@", task.id))
                let daysBetween = (task.dueDate - Date()).day!
                var totalExpectedDuration: Double = 0
                var expectedDurationUsed: Double = 0
                for subTask in subTasks {
                    if !subTask.completed {
                        totalExpectedDuration += subTask.expectedDuration
                    }
                }
                if totalExpectedDuration != 0 {
                    for subTask in subTasks {
                        if !subTask.completed {
                            let daysToAdd = Int(Double(daysBetween) * (subTask.expectedDuration + expectedDurationUsed)/totalExpectedDuration)
                            let newDueDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date())!
                            expectedDurationUsed += subTask.expectedDuration
                            try localRealm.write {
                                subTask.dueDate = newDueDate
                                
                                getSubTasks()
                                print("Updated task with id \(id)! Title: \(subTask.title) with due date: \(subTask.dueDate)")
                            }
                        }
                    }
                }
            } catch {
                print("Error updating task \(id) to Realm: \(error)")
            }
        }
    }
    
    func updateTasks(id: ObjectId, title: String, progress: Double, priority: Int, attachedNotes: String, dueDate: Date, expectedDuration: Double) {
        if let localRealm = localRealm {
            do {
                let tasksToUpdate = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !tasksToUpdate.isEmpty else {return}
                let taskToUpdate = tasksToUpdate[0]
                
                getSubTasks()
                let subTasks = localRealm.objects(SubTask.self).filter(NSPredicate(format: "parentId == %@", id))
                let reward = localRealm.objects(Reward.self)[0]
                
                // Update and write values
                if (!subTasks.isEmpty) {
                    // If Subtasks exist
                    var subTaskSum: Double = 0
                    for subTask in subTasks {
                        subTaskSum += (subTask.progress / Double(subTasks.count))
                    }
                    
                    try localRealm.write {
                        if (title != "") {
                            taskToUpdate.title = title
                        }
                        taskToUpdate.progress = subTaskSum
                        if (attachedNotes.isEmpty) {
                            taskToUpdate.attachedNotes = attachedNotes
                        }
                        taskToUpdate.priority = priority
                        taskToUpdate.dueDate = dueDate
                        taskToUpdate.expectedDuration = expectedDuration
                        
                        // Refresh
                        getTasks()
                        print("Updated task with id \(id)! Title: \(taskToUpdate.title), Progress: \(taskToUpdate.progress)")
                    }
                } else {
                    // If no subTasks
                    let initialProgress = taskToUpdate.progress
                    try localRealm.write {
                        if (title != "") {
                            taskToUpdate.title = title
                        }
                        taskToUpdate.progress = progress
                        if progress == 1 {
                            taskToUpdate.completed = true
                        } else {
                            taskToUpdate.completed = false
                        }
                        if (attachedNotes != "") {
                            taskToUpdate.attachedNotes = attachedNotes
                        }
                        taskToUpdate.priority = priority
                        taskToUpdate.dueDate = dueDate
                        taskToUpdate.expectedDuration = expectedDuration
                        
                        // Refresh
                        getTasks()
                        print("Updated task with id \(id)! Title: \(taskToUpdate.title), Progress: \(taskToUpdate.progress)")
                    }
                    updateReward(valueToAdd: Double(reward.creditsEarnedPerHourWork) * (taskToUpdate.progress - initialProgress) * taskToUpdate.expectedDuration)
                }
                setSubTaskDueDates(id: taskToUpdate.id)
                checkCompletion(id: taskToUpdate.id)
            } catch {
                print("Error updating task \(id) to Realm: \(error)")
            }
        }
    }
    
    func updateTasks(id: ObjectId, completed: Bool) {
        if let localRealm = localRealm {
            do {
                let tasksToUpdate = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !tasksToUpdate.isEmpty else {return}
                let taskToUpdate = tasksToUpdate[0]
                
                getSubTasks()
                getRewards()
                let subTasks = localRealm.objects(SubTask.self).filter(NSPredicate(format: "parentId == %@", id))
                let reward = localRealm.objects(Reward.self)[0]
                
                // Update and write values
                if (!subTasks.isEmpty) {
                    // If Subtasks exist
                    
                    // Update all subTasks to completion
                    for subTask in subTasks {
                        let initialProgress = subTask.progress
                        try localRealm.write {
                            subTask.completed = completed
                            if completed {
                                subTask.progress = 1
                            } else {
                                subTask.progress = 0
                            }
                            getSubTasks()
                            print("Updated sub task with id \(id)! Title: \(subTask.title), Completed status: \(completed), Progress: \(subTask.progress)")
                        }
                        updateReward(valueToAdd: Double(reward.creditsEarnedPerHourWork) * (subTask.progress - initialProgress) * subTask.expectedDuration)
                    }
                    // Just change task also
                    try localRealm.write {
                        taskToUpdate.completed = completed
                        if completed {
                            taskToUpdate.progress = 1
                        } else {
                            taskToUpdate.progress = 0
                        }
                        getTasks()
                        print("Updated task with id \(id)! Title: \(taskToUpdate.title), Completed status: \(completed), Progress: \(taskToUpdate.progress)")
                    }
                } else {
                    // If no subTasks
                    let initialProgress = taskToUpdate.progress
                    try localRealm.write {
                        taskToUpdate.completed = completed
                        if completed {
                            taskToUpdate.progress = 1
                        } else {
                            taskToUpdate.progress = 0
                        }
                        getTasks()
                        print("Updated task with id \(id)! Title: \(taskToUpdate.title), Completed status: \(completed), Progress: \(taskToUpdate.progress)")
                    }
                    updateReward(valueToAdd: Double(reward.creditsEarnedPerHourWork) * (taskToUpdate.progress - initialProgress) * taskToUpdate.expectedDuration)
                }
            } catch {
                print("Error updating task \(id) to Realm: \(error)")
            }
        }
    }
    
    func updateReward(valueToAdd: Double) {
        if let localRealm = localRealm {
            do {
                let rewardToUpdate = localRealm.objects(Reward.self)
                guard !rewardToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    //if (valueToAdd + rewardToUpdate[0].creditValue < 0) {
                    //    rewardToUpdate[0].creditValue = 0
                    //} else {
                    //    rewardToUpdate[0].creditValue = valueToAdd + rewardToUpdate[0].creditValue
                    //}
                    rewardToUpdate[0].creditValue = valueToAdd + rewardToUpdate[0].creditValue
                    
                    getRewards()
                    print("Updated reward value with id \(rewardToUpdate[0].id)! Value: \(rewardToUpdate[0].creditValue)")
                }
            } catch {
                print("Error updating reward to Realm: \(error)")
            }
        }
    }
    
    func updateRewardItem(id: ObjectId, creditValue: Double) {
        if let localRealm = localRealm {
            do {
                let rewardItemToUpdate = localRealm.objects(RewardItem.self).filter(NSPredicate(format: "id == %@", id))
                guard !rewardItemToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    rewardItemToUpdate[0].creditValue = creditValue
                    
                    getRewardItems()
                    print("Updated reward item with id \(rewardItemToUpdate[0].id)! Value: \(rewardItemToUpdate[0].creditValue)")
                }
            } catch {
                print("Error updating reward item to Realm: \(error)")
            }
        }
    }
    
    func updateReward(creditsEarnedPerExercise: Int) {
        if let localRealm = localRealm {
            do {
                let rewardToUpdate = localRealm.objects(Reward.self)
                guard !rewardToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    rewardToUpdate[0].creditsEarnedPerExercise = creditsEarnedPerExercise
                    
                    getRewards()
                    print("Updated reward creditsEarnedPerExercise with id \(rewardToUpdate[0].id)! Value: \(rewardToUpdate[0].creditsEarnedPerExercise)")
                }
            } catch {
                print("Error updating reward to Realm: \(error)")
            }
        }
    }
    
    func updateReward(creditsEarnedPerHourWork: Int) {
        if let localRealm = localRealm {
            do {
                let rewardToUpdate = localRealm.objects(Reward.self)
                guard !rewardToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    rewardToUpdate[0].creditsEarnedPerHourWork = creditsEarnedPerHourWork
                    
                    getRewards()
                    print("Updated reward creditsEarnedPerHourWork with id \(rewardToUpdate[0].id)! Value: \(rewardToUpdate[0].creditsEarnedPerHourWork)")
                }
            } catch {
                print("Error updating reward to Realm: \(error)")
            }
        }
    }
    
    func updateExercise(id: ObjectId, creditValue: Double) {
        if let localRealm = localRealm {
            do {
                let exerciseToUpdate = localRealm.objects(Exercise.self).filter(NSPredicate(format: "id == %@", id))
                guard !exerciseToUpdate.isEmpty else {return}
                
                try localRealm.write {
                    exerciseToUpdate[0].creditValue = creditValue
                    
                    getRewards()
                    print("Updated reward creditsEarnedPerHourWork with id \(exerciseToUpdate[0].id)! Value: \(exerciseToUpdate[0].creditValue)")
                }
            } catch {
                print("Error updating reward to Realm: \(error)")
            }
        }
    }
    
    func updateSubTasks(id: ObjectId, title: String, progress: Double, priority: Int, attachedNotes: String, expectedDuration: Double) {
        if let localRealm = localRealm {
            do {
                let subTasksToUpdate = localRealm.objects(SubTask.self).filter(NSPredicate(format: "id == %@", id))
                guard !subTasksToUpdate.isEmpty else {return}
                let subTaskToUpdate = subTasksToUpdate[0]
                let reward = localRealm.objects(Reward.self)[0]
                let initialProgress = subTaskToUpdate.progress
                
                // Update and write values
                try localRealm.write {
                    if (title != "") {
                        subTaskToUpdate.title = title
                    }
                    subTaskToUpdate.progress = progress
                    if (progress == 1) {
                        subTaskToUpdate.completed = true
                    } else {
                        subTaskToUpdate.completed = false
                    }
                    subTaskToUpdate.attachedNotes = attachedNotes
                    
                    subTaskToUpdate.priority = priority
                    subTaskToUpdate.expectedDuration = expectedDuration

                    // Refresh
                    getSubTasks()
                    
                    print("Updated subTask with id \(id)! Title: \(subTaskToUpdate.title), Progress: \(subTaskToUpdate.progress)")
                }
                updateReward(valueToAdd: Double(reward.creditsEarnedPerHourWork) * (subTaskToUpdate.progress - initialProgress) * subTaskToUpdate.expectedDuration)
            } catch {
                print("Error updating subTask \(id) to Realm: \(error)")
            }
        }
    }
    
    func updateSubTasks(id: ObjectId, completed: Bool) {
        if let localRealm = localRealm {
            do {
                let subTasksToUpdate = localRealm.objects(SubTask.self).filter(NSPredicate(format: "id == %@", id))
                guard !subTasksToUpdate.isEmpty else {return}
                let subTaskToUpdate = subTasksToUpdate[0]
                let reward = localRealm.objects(Reward.self)[0]
                let initialProgress = subTaskToUpdate.progress
                
                try localRealm.write {
                    subTaskToUpdate.completed = completed
                    if completed {
                        subTaskToUpdate.progress = 1
                    } else {
                        subTaskToUpdate.progress = 0
                    }
                    
                    getSubTasks()
                    print("Updated task with id \(id)! Title: \(subTaskToUpdate.title), Completed status: \(completed), Progress: \(subTaskToUpdate.progress)")
                }
                updateReward(valueToAdd: Double(reward.creditsEarnedPerHourWork) * (subTaskToUpdate.progress - initialProgress) * subTaskToUpdate.expectedDuration)
            } catch {
                print("Error updating task \(id) to Realm: \(error)")
            }
        }
    }
    
    func checkCompletion(id: ObjectId) {
        // Function required to be called after Task update (not bool only), use for summing subTasks and allowing progress==1 to relate properly to "complete" variable
        if let localRealm = localRealm {
            do {
                let task = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))[0]
                let subTasks = localRealm.objects(SubTask.self).filter(NSPredicate(format: "parentId == %@", task.id))
                if !subTasks.isEmpty {
                    // First check for each subTask that completion/progress line up
                    var sumProgress: Double = 0
                    for subTask in subTasks {
                        sumProgress += subTask.progress
                    }
                    // Ensure if all subTasks complete - then
                    if sumProgress==1 {
                        try localRealm.write {
                            task.completed = true
                            getTasks()
                            print("Updated task with id \(task.id)! Title: \(task.title), Completed status: \(task.completed), Progress: \(task.progress)")
                        }
                    } else {
                        if task.completed == true {
                            try localRealm.write {
                                task.completed = false
                                getTasks()
                                print("Updated task with id \(task.id)! Title: \(task.title), Completed status: \(task.completed), Progress: \(task.progress)")
                            }
                        }
                    }
                } else {
                    // No SubTasks so ensure only completed if progress allows
                    let initialProgress = task.progress
                    if initialProgress == 1 {
                        try localRealm.write {
                            task.completed = true
                            getTasks()
                        }
                    } else {
                        if task.completed == true {
                            try localRealm.write {
                                task.completed = false
                                getTasks()
                            }
                        }
                    }
                }
            } catch {
                print("Error updating Realm with checkCompletion(): \(error)")
            }
        }
    }
    
    func deleteWorkout(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let workoutToDelete = localRealm.objects(Workout.self).filter(NSPredicate(format: "id == %@", id))
                guard !workoutToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(workoutToDelete)
                    getWorkouts()
                    print("Deleted workout with id \(id)")
                }
            } catch {
                print("Error deleting workout \(id) from Realm \(error)")
            }
        }
    }
    
    func deleteExercise(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let exerciseToDelete = localRealm.objects(Exercise.self).filter(NSPredicate(format: "id == %@", id))
                guard !exerciseToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(exerciseToDelete)
                    getExercises()
                    print("Deleted exercise with id \(id)")
                }
            } catch {
                print("Error deleting exercise \(id) from Realm \(error)")
            }
        }
    }
    
    func deleteTask(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let taskToDelete = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !taskToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(taskToDelete)
                    getTasks()
                    print("Deleted task with id \(id)")
                }
            } catch {
                print("Error deleting task \(id) from Realm \(error)")
            }
        }
    }
    
    func deleteReward(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let rewardToDelete = localRealm.objects(Reward.self).filter(NSPredicate(format: "id == %@", id))
                guard !rewardToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(rewardToDelete)
                    getRewards()
                    print("Deleted reward with id \(id)")
                }
            } catch {
                print("Error deleting reward \(id) from Realm \(error)")
            }
        }
    }
    
    func deleteRewardItem(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let rewardItemToDelete = localRealm.objects(RewardItem.self).filter(NSPredicate(format: "id == %@", id))
                guard !rewardItemToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(rewardItemToDelete)
                    getRewardItems()
                    print("Deleted reward item with id \(id)")
                }
            } catch {
                print("Error deleting reward item \(id) from Realm \(error)")
            }
        }
    }
    
    func deleteSubTask(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let subTaskToDelete = localRealm.objects(SubTask.self).filter(NSPredicate(format: "id == %@", id))
                guard !subTaskToDelete.isEmpty else {return}
                
                try localRealm.write {
                    localRealm.delete(subTaskToDelete)
                    getTasks()
                    print("Deleted subTask with id \(id)")
                }
            } catch {
                print("Error deleting subTask \(id) from Realm \(error)")
            }
        }
    }
}

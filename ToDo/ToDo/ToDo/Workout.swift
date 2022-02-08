//
//  Workout.swift
//  ToDo
//
//  Created by Freddie Cassidy on 22/01/2022.
//

import Foundation
import RealmSwift
import CoreImage

class Workout: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var workoutType: String
    @Persisted var workoutDate: Date
    @Persisted var exercises: String
    @Persisted var sets: String
    @Persisted var reps: String
    @Persisted var weights: String
}

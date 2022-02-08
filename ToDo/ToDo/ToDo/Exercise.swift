//
//  Exercise.swift
//  ToDo
//
//  Created by Freddie Cassidy on 25/01/2022.
//

import Foundation
import RealmSwift
import Network

class Exercise: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var exerciseName: String
    @Persisted var workoutGroup: String
    @Persisted var creditValue: Double
}

//
//  Reward.swift
//  ToDo
//
//  Created by Freddie Cassidy on 25/01/2022.
//

import Foundation
import RealmSwift
import CoreImage

class Reward: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var creditValue: Double
    @Persisted var creditsEarnedPerExercise: Int
    @Persisted var creditsEarnedPerHourWork: Int
}

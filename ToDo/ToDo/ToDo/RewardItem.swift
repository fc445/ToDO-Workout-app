//
//  RewardItem.swift
//  ToDo
//
//  Created by Freddie Cassidy on 26/01/2022.
//

import Foundation
import RealmSwift
import CoreImage

class RewardItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var rewardItemName: String
    @Persisted var creditValue: Double
}

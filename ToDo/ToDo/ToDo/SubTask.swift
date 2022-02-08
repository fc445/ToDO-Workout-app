//
//  SubTask.swift
//  ToDo
//
//  Created by Freddie Cassidy on 13/01/2022.
//

import Foundation
import RealmSwift
import CoreImage

class SubTask: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var completed = false
    @Persisted var progress: Double
    @Persisted var priority: Int
    @Persisted var attachedNotes: String
    @Persisted var dueDate: Date
    @Persisted var parentId: ObjectId
    @Persisted var expectedDuration: Double
}

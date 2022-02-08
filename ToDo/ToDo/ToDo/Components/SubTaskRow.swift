//
//  SubTaskView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 13/01/2022.
//

import SwiftUI
import RealmSwift

struct SubTaskRow: View {
    var subTaskId: ObjectId
    var title: String
    var completed: Bool
    var progress: Double
    var priorityString: String
    var dueDate: Date
    var expectedDuration: Double
    
    @EnvironmentObject var realmManager: RealmManager
    @State var showEditSubTaskView = false
    @State var showEditSubTaskViewId = ObjectId.generate()
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: completed ? "checkmark.circle": "circle")
                Spacer()
                Text(title)
                Spacer()
                Text("Due: \(dueDate.getFormattedDate(format: "dd/MM"))")
                Spacer()
                Text(priorityString)
                    .font(.title)
            }
            HStack(spacing: 20) {
                ProgressView(value: progress)
            }
        }
        .onTapGesture {
            showEditSubTaskView.toggle()
            showEditSubTaskViewId = subTaskId
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                realmManager.deleteSubTask(id: subTaskId)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                realmManager.updateSubTasks(id: subTaskId, completed: !completed)
            } label: {
                Label("Complete", systemImage: "checkmark").foregroundColor(.white)
            }.tint(.green)
        }
        .sheet(isPresented: $showEditSubTaskView) {
            EditSubTaskView(subTaskId: $showEditSubTaskViewId, title: title, progressLocal: Int(progress*100), dueDate: dueDate, expectedDuration: expectedDuration, priorityString: priorityString)
                .environmentObject(realmManager)
        }
    }
}

struct SubTaskRow_Previews: PreviewProvider {
    static var previews: some View {
        SubTaskRow(subTaskId: ObjectId.generate(), title: "Do Laundry", completed: true, progress: 0.3, priorityString: "!!", dueDate: Date(), expectedDuration: 2)
    }
}

//
//  TaskRow.swift
//  ToDo
//
//  Created by Freddie Cassidy on 11/01/2022.
//

import SwiftUI
import RealmSwift

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

struct TaskRow: View {
    var taskId: ObjectId
    var title: String
    var completed: Bool
    var progress: Double
    var priorityString: String
    var dueDate: Date
    var expectedDuration: Double
    
    @EnvironmentObject var realmManager: RealmManager
    @State var showEditTaskView = false
    @State var showEditTaskViewId = ObjectId.generate()
    
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
            showEditTaskView.toggle()
            showEditTaskViewId = taskId
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                realmManager.deleteTask(id: taskId)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                realmManager.updateTasks(id: taskId, completed: !completed)
            } label: {
                Label("Complete", systemImage: "checkmark").foregroundColor(.white)
            }.tint(.green)
        }
        .sheet(isPresented: $showEditTaskView) {
            EditTaskView(taskId: $showEditTaskViewId, title: title, progressLocal: Int(progress*100), priorityString: priorityString, dueDate: dueDate, expectedDuration: expectedDuration)
                .environmentObject(realmManager)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(taskId: ObjectId.generate(), title: "Do Laundry", completed: true, progress: 0.3, priorityString: "!", dueDate: Date(), expectedDuration: 2)
    }
}

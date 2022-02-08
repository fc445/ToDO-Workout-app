//
//  TasksView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 11/01/2022.
//

import SwiftUI
import Network
import RealmSwift

struct TasksView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showAddTaskView = false
    @State private var showEditTaskView = false
    @State private var showEditTaskViewId = ObjectId.generate()
    
    var body: some View {
        ZStack {
            VStack {
                // Tasks
                Group {
                    // Unfinished Tasks
                    Group {
                        Text("Unfinished Tasks")
                            .font(.title3).bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                        
                        List {
                            ForEach(realmManager.tasks, id: \.id) {
                                task in
                                if !task.isInvalidated {
                                    if !task.completed {
                                        TaskRow(taskId: task.id, title: task.title, completed: task.completed, progress: task.progress, priorityString: String(repeating: "!", count: task.priority), dueDate: task.dueDate, expectedDuration: task.expectedDuration)
                                            .environmentObject(realmManager)
                                    }
                                }
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .onAppear {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        }
                    }
                    
                    // Completed Tasks
                    Group {
                        Text("Completed Tasks")
                            .font(.title3).bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                        
                        List {
                            ForEach(realmManager.tasks, id: \.id) {
                                task in
                                if !task.isInvalidated {
                                    if task.completed {
                                        TaskRow(taskId: task.id, title: task.title, completed: task.completed, progress: task.progress, priorityString: String(repeating: "!", count: task.priority), dueDate: task.dueDate, expectedDuration: task.expectedDuration)
                                            .environmentObject(realmManager)
                                    }
                                }
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .onAppear {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hue: 0.505, saturation: 0.902, brightness: 0.805))
        
            // Add Task Button
            Group {
                SmallAddButton()
                    .padding()
                    .onTapGesture {
                        showAddTaskView.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView()
                .environmentObject(realmManager)
        }
    }
}

//struct TasksView_Previews: PreviewProvider {
//    static var previews: some View {
//        TasksView()
//            .environmentObject(RealmManager())
//    }
//}

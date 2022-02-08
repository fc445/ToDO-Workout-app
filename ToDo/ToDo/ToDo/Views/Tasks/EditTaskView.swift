//
//  EditTasksView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 11/01/2022.
//

import SwiftUI
import Network
import RealmSwift

struct EditTaskView: View {
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var taskId: ObjectId
    @State var title: String
    @State var progressLocal: Int
    @State var showAddSubTaskView = false
    @State var showEditSubTaskView = false
    @State var showEditSubTaskViewId = ObjectId.generate()
    
    @State var priorityString: String
    @State var dueDate: Date
    
    @State var expectedDuration: Double
    
    @State var notesArray = Array(repeating: "", count: 10)
    @State var nNotes: Int = 0
    
    
    var body: some View {
        let task = realmManager.localRealm!.objects(Task.self).filter(NSPredicate(format: "id == %@", taskId))[0]
        let subTasks = realmManager.localRealm!.objects(SubTask.self).filter(NSPredicate(format: "parentId == %@", task.id))
        let notes = task.attachedNotes.components(separatedBy: ",")
        
        VStack(alignment: .leading, spacing: 20) {
            // Page Title
            Group {
                Text("Edit Task")
                    .font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Task Name
            TextField("Setting task name (already set tho)", text: $title)
                .textFieldStyle(.roundedBorder)
            
            // SubTasks
            Group {
                if (subTasks.count != 0) {
                    Section("SubTasks") {
                        List {
                            ForEach(realmManager.subTasks, id: \.id) {
                                subTask in
                                if (subTask.parentId == taskId) {
                                    SubTaskRow(subTaskId: subTask.id, title: subTask.title, completed: subTask.completed, progress: subTask.progress, priorityString: String(repeating: "!", count: subTask.priority), dueDate: subTask.dueDate, expectedDuration: subTask.expectedDuration)
                                        .environmentObject(realmManager)
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                } else {
                    Stepper(value: $progressLocal,
                        in: 0...100,
                        step: 5) {
                            Text("\(progressLocal)% complete.")
                        }
                        .padding(10)
                }
                Button {
                    showAddSubTaskView.toggle()
                } label: {
                    Text("Add Sub Task")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color(.orange))
                        .cornerRadius(30)
                }
            }
            
            // Notes
            Group {
                Text("Notes")
                
                List {
                    ForEach(0...(notes.count-1), id: \.self) {i in
                        let note = notes[i]
                        if (i < nNotes) {
                            TextField(note=="" ? "Add Note: " : note, text: $notesArray[i])
                                .textFieldStyle(.roundedBorder)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                Button {
                    nNotes += 1
                } label: {
                    Text("Add Note")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color(.orange))
                        .cornerRadius(30)
                }
            }
            
            // Expected Duration
            if subTasks.isEmpty {
                Stepper(value: $expectedDuration, in: 0...10, step: 0.25) {
                    Text("Expected Hours to Complete: \(expectedDuration, specifier: "%.2f")")
                }
            }
            
            // Due Date
            DatePicker("Enter Due Date: ", selection: $dueDate, displayedComponents: [.date])
            
            // Priority
            Form {
                Picker(selection: $priorityString, label: Text("Select Priority")) {
                    ForEach(["!", "!!", "!!!"], id: \.self) {
                        Text($0)
                            .font(.title)
                    }
                }.pickerStyle(.segmented)
            }
            
            // Update Task Button
            Group {
                Button {
                    realmManager.updateTasks(id: task.id, title: title, progress: Double(progressLocal)/Double(100), priority: (priorityString.components(separatedBy: "!").count - 1), attachedNotes: notesArray.joined(separator: ","), dueDate: dueDate, expectedDuration: expectedDuration)
                    dismiss()
                } label: {
                    Text("Confirm Edit Task")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                        .cornerRadius(30)
                }            }
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .background(Color(hue: 0.505, saturation: 0.902, brightness: 0.805))
        .sheet(isPresented: $showAddSubTaskView) {
            AddSubTaskView(parentId: task.id)
        }
    }
}

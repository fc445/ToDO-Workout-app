//
//  EditSubTasksView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 16/01/2022.
//

import SwiftUI
import Network
import RealmSwift

struct EditSubTaskView: View {
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var subTaskId: ObjectId
    @State var title: String
    @State var progressLocal: Int
    @State var dueDate: Date
    @State var expectedDuration: Double
    
    @State var priorityString: String
    @State var notesArray = Array(repeating: "", count: 10)
    @State var nNotes: Int = 0
    
    var body: some View {
        let subTask = realmManager.localRealm!.objects(SubTask.self).filter(NSPredicate(format: "id == %@", subTaskId))[0]
        let notes = subTask.attachedNotes.components(separatedBy: ",")
        VStack(alignment: .leading, spacing: 20) {
            // Page Title
            Group {
                Text("Edit SubTask")
                    .font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Set Title
            TextField("Setting subtask name (already set tho)", text: $title)
                .textFieldStyle(.roundedBorder)
            
            // Set Progress
            Stepper(value: $progressLocal,
                    in: 0...100,
                    step: 5) {
                        Text("\(progressLocal)% complete.")
                    }
                        .padding(10)
            
            // Notes
            Group {
                Text("Notes")
                // Ensure all preset notes are shown
                List {
                    ForEach(0...(notes.count-1), id: \.self) {i in
                        let note = notes[i]
                        if (i < nNotes) {
                            TextField(note=="" ? "Add Note: " : note, text: $notesArray[i])
                                .textFieldStyle(.roundedBorder)
                                .listRowSeparator(.hidden)
                        }
                    }
                }.listRowSeparator(.hidden)
                
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
            Stepper(value: $expectedDuration, in: 0...10, step: 0.25) {
                Text("Expected Hours to Complete: \(expectedDuration, specifier: "%.2f")")
            }
            
            // Priority
            Form {
                Picker(selection: $priorityString, label: Text("Select Priority")) {
                    ForEach(["!", "!!", "!!!"], id: \.self) {
                        Text($0)
                            .font(.title)
                    }
                }.pickerStyle(.segmented)
            }
            
            // Confirm Update SubTask Button
            Group {
                Button {
                    realmManager.updateSubTasks(id: subTask.id, title: title, progress: Double(progressLocal)/Double(100), priority: (priorityString.components(separatedBy: "!").count - 1), attachedNotes: notesArray.joined(separator: ","), expectedDuration: expectedDuration)
                    dismiss()
                } label: {
                    Text("Confirm Edit SubTask")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                        .cornerRadius(30)
                }
            }
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .background(Color(hue: 0.505, saturation: 0.902, brightness: 0.805))
    }
}

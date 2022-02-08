//
//  AddTaskView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 11/01/2022.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var title: String = ""
    @State private var priority: Int = 1
    @State private var dueDate = Date()
    @State private var expectedDuration: Double = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create a New Task")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Enter your task here", text: $title)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
            
            DatePicker("Enter Due Date: ", selection: $dueDate, displayedComponents: [.date])
            
            Stepper(value: $expectedDuration, in: 0...10, step: 0.25) {
                Text("Expected Hours to Complete: \(expectedDuration, specifier: "%.2f")")
            }
            
            Button {
                if title != "" {
                    realmManager.addTask(taskTitle: title, dueDate: dueDate, expectedDuration: expectedDuration)
                }
                dismiss()
            } label: {
                Text("Add Task")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                    .cornerRadius(30)
            }
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .background(Color(hue: 0.505, saturation: 0.902, brightness: 0.805))
    }
}

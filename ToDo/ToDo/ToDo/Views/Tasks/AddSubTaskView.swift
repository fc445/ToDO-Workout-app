//
//  AddSubTaskView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 13/01/2022.
//

import SwiftUI
import RealmSwift

struct AddSubTaskView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var title: String = ""
    @State private var dueDate = Date()
    @State private var expectedDuration: Double = 0
    @Environment(\.dismiss) var dismiss
    
    var parentId: ObjectId
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create a New SubTask")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Enter your SubTask here", text: $title)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
            
            Stepper(value: $expectedDuration, in: 0...10, step: 0.25) {
                Text("Expected Hours to Complete: \(expectedDuration, specifier: "%.2f")")
            }
            
            Button {
                if title != "" {
                    realmManager.addSubTask(taskTitle: title, parentId: parentId, expectedDuration: expectedDuration)
                }
                dismiss()
            } label: {
                Text("Add SubTask")
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

//
//  ExerciseSettingsRow.swift
//  ToDo
//
//  Created by Freddie Cassidy on 25/01/2022.
//

import SwiftUI
import RealmSwift

struct ExerciseSettingsRow: View {
    @EnvironmentObject var realmManager: RealmManager
    @State var exerciseName: String
    @State var creditValue: Double
    var exerciseId: ObjectId
    @State var showEditCreditValue = false
    
    var body: some View {
        HStack {
            Text(exerciseName)
            
            Spacer()
            
            Text("\(creditValue, specifier: "%.1f")")
                .font(.title3)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                realmManager.deleteExercise(id: exerciseId)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                showEditCreditValue.toggle()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.green)
        }
        .sheet(isPresented: $showEditCreditValue) {
            VStack {
                Form {
                    Text("Choose Credit Value")
                    Stepper(value: $creditValue, in: 0...5, step: 0.1) {
                        Text("\(creditValue, specifier: "%.1f")")
                    }
                }
                Button {
                    realmManager.updateExercise(id: exerciseId, creditValue: creditValue)
                    showEditCreditValue.toggle()
                } label: {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                        .cornerRadius(30)
                }
            }
        }
    }
}

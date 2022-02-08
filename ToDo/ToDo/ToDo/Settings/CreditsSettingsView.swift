//
//  CreditsSettingsView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 26/01/2022.
//

import SwiftUI

struct CreditsSettingsView: View {
    @EnvironmentObject var realmManager: RealmManager
    @Environment(\.dismiss) var dismiss
    
    @State var creditsEarnedPerExercise: Int
    @State var creditsEarnedPerHourWork: Int
    
    var body: some View {
        VStack {
            Text("Current Credits: \(realmManager.rewards[0].creditValue, specifier: "%.1f")")
            
            Text("Set amount of credits earned per activity")
            
            Stepper(value: $creditsEarnedPerExercise, in: 0...5) {
                Text("Credits per Set: \(creditsEarnedPerExercise)")
            }
            
            Stepper(value: $creditsEarnedPerHourWork, in: 0...5) {
                Text("Credits per Hour of Work: \(creditsEarnedPerHourWork)")
            }
            
            Button {
                realmManager.updateReward(creditsEarnedPerExercise: creditsEarnedPerExercise)
                realmManager.updateReward(creditsEarnedPerHourWork: creditsEarnedPerHourWork)
                dismiss()
            } label: {
                Text("Submit Updates")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(hue: 0.63, saturation: 0.807, brightness: 0.797))
                    .cornerRadius(30)
            }
            Button {
                realmManager.updateReward(valueToAdd: -realmManager.rewards[0].creditValue)
            } label: {
                Text("Reset Credits")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(.gray)
                    .cornerRadius(30)
            }
        }
    }
}

struct CreditsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsSettingsView(creditsEarnedPerExercise: 2, creditsEarnedPerHourWork: 1)
    }
}

//
//  SettingsView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 13/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var realmManager: RealmManager
    
    var body: some View {
        TabView {
            SettingsExerciseView()
                .environmentObject(realmManager)
                .tabItem {
                    Label("Exercises", systemImage: "bicycle")
                }
            CreditsSettingsView(creditsEarnedPerExercise: realmManager.rewards[0].creditsEarnedPerExercise, creditsEarnedPerHourWork: realmManager.rewards[0].creditsEarnedPerHourWork)
                .environmentObject(realmManager)
                .tabItem {
                    Label("Credits", systemImage: "sparkles")
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

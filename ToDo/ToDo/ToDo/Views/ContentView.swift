//
//  ContentView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 11/01/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var realmManager = RealmManager()
    @State private var showSettingsView = false
    
    var body: some View {
        ZStack {
            TabView {
                TasksView()
                    .environmentObject(realmManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .tabItem {
                        Label("To-Do List", systemImage: "list.dash")
                    }
                
                WorkoutsView()
                    .environmentObject(realmManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .tabItem {
                        Label("Workouts", systemImage: "bicycle")
                    }
                
                RewardsView()
                    .environmentObject(realmManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .tabItem {
                        Label("Rewards", systemImage: "sparkles")
                    }
            }
            
            ZStack(alignment: .topTrailing) {
                Button(action: {
                    showSettingsView.toggle()
                }) {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width:25, height:25)
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
                    .environmentObject(realmManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  RewardsView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 22/01/2022.
//

import SwiftUI
import RealmSwift
import Network

struct RewardsView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State var showSpendCreditsView = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Total Credits")
                .font(.title3)
            
            Text("\(realmManager.rewards[0].creditValue, specifier: "%.1f")")
                .font(.largeTitle)
            
            Spacer()
            
            Button {
                showSpendCreditsView.toggle()
            } label: {
                Text("Spend Credits")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(.blue)
                    .cornerRadius(30)
            }
        }
        .sheet(isPresented: $showSpendCreditsView) {
            SpendCreditsView(rewardItems: realmManager.rewardItems)
                .environmentObject(realmManager)
        }
    }
}

struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsView()
    }
}

//
//  AddRewardItemView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 27/01/2022.
//

import SwiftUI
import RealmSwift

struct AddRewardItemView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var rewardItemName: String = ""
    @State private var creditValue: Double = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create a New Reward Item")
                .font(.title3).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Enter reward item name", text: $rewardItemName)
                .textFieldStyle(.roundedBorder)
            
            Stepper(value: $creditValue, in: 0...5, step: 0.1) {
                Text("Credit value: \(creditValue, specifier: "%.1f")")
            }
            
            Button {
                if rewardItemName != "" {
                    realmManager.addRewardItem(rewardItemName: rewardItemName, creditValue: creditValue)
                }
                dismiss()
            } label: {
                Text("Add Reward Item")
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

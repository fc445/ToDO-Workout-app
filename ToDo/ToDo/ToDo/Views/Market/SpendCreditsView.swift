//
//  SpendCreditsView.swift
//  ToDo
//
//  Created by Freddie Cassidy on 26/01/2022.
//

import SwiftUI
import RealmSwift

struct SpendCreditsView: View {
    @EnvironmentObject var realmManager: RealmManager
    var rewardItems: [RewardItem]
    @State var isSelectedArray = Array(repeating: false, count: 20)
    @State var isAddRewardItemViewShown = false
    
    var body: some View {
        VStack {
            List {
                ForEach(realmManager.rewardItems, id: \.id) {rewardItem in
                    if !rewardItem.isInvalidated {
                        let i = realmManager.rewardItems.firstIndex{$0 === rewardItem}!
                        RewardItemRow(rewardItemName: rewardItem.rewardItemName, creditValue: rewardItem.creditValue, isSelected: isSelectedArray[i])
                            .onTapGesture {
                                isSelectedArray[i].toggle()
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    realmManager.deleteRewardItem(id: rewardItem.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            Button {
                isAddRewardItemViewShown.toggle()
            } label: {
                Text("Add New Reward Item")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(.blue)
                    .cornerRadius(30)
            }
        }
        .sheet(isPresented: $isAddRewardItemViewShown) {
            AddRewardItemView()
        }
    }
}

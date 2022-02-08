//
//  RewardItemRow.swift
//  ToDo
//
//  Created by Freddie Cassidy on 26/01/2022.
//

import SwiftUI

struct RewardItemRow: View {
    var rewardItemName: String
    var creditValue: Double
    var isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "checkmark.circle": "circle")
            
            Spacer()
            
            Text(rewardItemName)
            
            Spacer()
            
            Text("\(creditValue, specifier: "%.1f")")
        }
    }
}

struct RewardItemRow_Previews: PreviewProvider {
    static var previews: some View {
        RewardItemRow(rewardItemName: "TV", creditValue: 0.6, isSelected: false)
    }
}

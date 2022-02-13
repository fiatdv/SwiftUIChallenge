//
//  TransactionTotalsView.swift
//  TechChallenge
//
//  Created by Felipe Gomez on 2/11/22.
//

import SwiftUI

struct TransactionTotalsView: View {
    @EnvironmentObject var avm: AllTransactionsVM

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(avm.categorySelected.rawValue)
                    .font(Font.system(.headline))
                    .foregroundColor(avm.categorySelected.background)
            }
            HStack {
                Text("Total spent:")
                    .fontWeight(.regular)
                    .secondary()
                Spacer()
                Text(avm.categoryTotal)
                    .fontWeight(.bold)
                    .secondary()
            }
        }
        .frame(minWidth: nil, idealWidth: nil, maxWidth: .infinity, minHeight: nil, idealHeight: nil, maxHeight: 46, alignment: .center)
        .padding()
        .overlay (
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor.opacity(0.8), lineWidth: 2)
        )
        .padding()
    }
}

struct TransactionTotalsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionTotalsView()
        .environmentObject(AllTransactionsVM())
    }
}

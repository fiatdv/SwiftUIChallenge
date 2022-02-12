//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI


struct TransactionListView: View {
    @EnvironmentObject var avm: AllTransactionsVM
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8.0) {
                
                CategorySelectionView()
                
                List {
                    ForEach(avm.transactions) { transaction in
                        TransactionView(vm: transaction)
                    }
                }
                
                Spacer()
                    .frame(maxHeight:82)
            }
            
            VStack(alignment: .trailing) {
                
                Spacer()
                
                TransactionTotalsView()
                    .frame(maxHeight:80)

            }
        }
        .animation(.easeIn, value: UUID())
        .listStyle(PlainListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Transactions")
        .navigationBarColor(backgroundColor: .white, titleColor: .black)
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
        .environmentObject(AllTransactionsVM())
    }
}
#endif

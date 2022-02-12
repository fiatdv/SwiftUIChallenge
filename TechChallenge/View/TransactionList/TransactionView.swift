//
//  TransactionView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI


struct TransactionView: View {
    @EnvironmentObject var avm: AllTransactionsVM
    @ObservedObject var vm: TransactionVM

    var body: some View {
        VStack {
            HStack {
                Text(vm.transaction.category.rawValue)
                    .font(.headline)
                    .foregroundColor(vm.transaction.category.color)
                Spacer()
                Image(systemName: vm.pinned ? "pin.fill" : "pin.slash.fill")
            }
            if vm.pinned {
                HStack {
                    vm.transaction.image
                        .resizable()
                        .frame(
                            width: 60.0,
                            height: 60.0,
                            alignment: .top
                        )
                    
                    VStack(alignment: .leading) {
                        Text(vm.transaction.name)
                            .secondary()
                        Text(vm.transaction.accountName)
                            .tertiary()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(vm.transaction.amount.formatted())")
                            .bold()
                            .secondary()
                        Text(vm.transaction.date.formatted)
                            .tertiary()
                    }
                }
            }
        }
        .padding(8.0)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .onTapGesture {
            vm.pinned.toggle()
            avm.pinTransaction(id: vm.transaction.id, isPinned: vm.pinned)
        }
    }
}

#if DEBUG
struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionView(vm: TransactionVM(ModelData.sampleTransactions[0]))
            TransactionView(vm: TransactionVM(ModelData.sampleTransactions[1]))
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .environmentObject(AllTransactionsVM())
    }
}
#endif

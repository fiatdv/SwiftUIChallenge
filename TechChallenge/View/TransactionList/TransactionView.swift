//
//  TransactionView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI


struct TransactionView: View {
    @EnvironmentObject var avm: AllTransactionsVM
    @ObservedObject var vm: TransactionModel

    var body: some View {
        VStack {
            HStack {
                Text(vm.category.rawValue)
                    .font(.headline)
                    .foregroundColor(vm.category.color)
                Spacer()
                Image(systemName: vm.isPinned ? "pin.fill" : "pin.slash.fill")
            }
            if vm.isPinned {
                HStack {
                    vm.image
                        .resizable()
                        .frame(
                            width: 60.0,
                            height: 60.0,
                            alignment: .top
                        )
                    
                    VStack(alignment: .leading) {
                        Text(vm.name)
                            .secondary()
                        Text(vm.accountName)
                            .tertiary()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(vm.amount.formatted())")
                            .bold()
                            .secondary()
                        Text(vm.date.formatted)
                            .tertiary()
                    }
                }
            }
        }
        .padding(8.0)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .onTapGesture {
            vm.isPinned.toggle()
            avm.pinTransaction()
        }
    }
}

#if DEBUG
struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionView(vm: ModelData.sampleTransactions[0])
            TransactionView(vm: ModelData.sampleTransactions[1])
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .environmentObject(AllTransactionsVM())
    }
}
#endif

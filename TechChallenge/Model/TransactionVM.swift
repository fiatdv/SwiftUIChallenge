//
//  TransactionVM.swift
//  TechChallenge
//
//  Created by Felipe Gomez on 2/11/22.
//

import Foundation

// Single transaction
class TransactionVM: ObservableObject, Identifiable {
    var transaction: TransactionModel
    @Published var pinned: Bool

    init(_ model: TransactionModel, isPinned: Bool = true) {
        transaction = model
        pinned = isPinned
    }
}

//
//  TransactionsViewModel.swift
//  TechChallenge
//
//  Created by Felipe Gomez on 2/10/22.
//

import Foundation
import SwiftUI

// MARK: - All transactions
class AllTransactionsVM: ObservableObject {

    @Published var transactions: [TransactionVM] = []   //For category selected

    // Verified in testFilterTransactionsByCategory
    @Published var categorySelected = "" {
        didSet {
            transactions = getAllTransactions(for: categorySelected)
            calcCategoryTotal()
        }
    }
    
    @Published var categoryTotal: String = ""            // Used in TotalsView
    
    @Published var graphPoints = [GraphPoint]()          // Insights
    
    private var unpinned = Set<Int>()                    // Holds all unpinned ids

    init() {
        categorySelected = Constants.all
    }
    
    func pinTransaction(id: Int, isPinned: Bool) {
        if isPinned {
            unpinned.remove(id)
        } else {
            unpinned.insert(id)
        }
        calcCategoryTotal()
    }
}

// MARK: - Support for calculations
extension AllTransactionsVM {

    private func calcCategoryTotal() {
        let total = calcPinnedTotal().formatted()
        categoryTotal = "$\(total)"
    }
    
    private func calcPinnedTotal() -> Double {
        let pinnedTransactions = transactions.filter { $0.pinned }
        return pinnedTransactions.reduce(0, { $0 + $1.transaction.amount })
    }

    private func calcTotal(for category: String) -> Double {
        let txs = getAllPinnedTransactions(for: category)
        let t = txs.reduce(0, { $0 + $1.transaction.amount })
        return round(100*t)/100
    }
    
    // Verified in testTotalsByCategory, testUnpinnedTransactionsTotalByCategory
    func calcTotalCategory() -> Double {
        calcTotal(for: categorySelected)
    }
    
    func calcTotalStr(_ category: String) -> String {
        let r: Double = calcTotal(for: category)
        return "$\(r.formatted())"
    }
    
    // Verified in testUnpinnedTransactionsTotalByCategory
    func calcAllTotals() -> Double {
        let txs = getAllPinnedTransactions()
        let t = txs.reduce(0, { $0 + $1.transaction.amount })
        return round(100*t)/100
    }
}

// MARK: - Support for getting transactions
extension AllTransactionsVM {
    
    private func getAllTransactions() -> [TransactionVM] {
        let results: [TransactionVM] = ModelData.sampleTransactions.compactMap({ model in
            let pinned = !unpinned.contains(model.id)
            return TransactionVM(model, isPinned: pinned)
        })
        return results
    }

    func getAllPinnedTransactions() -> [TransactionVM] {
        let results: [TransactionVM] = ModelData.sampleTransactions.compactMap({ model in
            let pinned = !unpinned.contains(model.id)
            if pinned {
                return TransactionVM(model)
            }
            return nil
        })
        return results
    }
    
    func getAllTransactions(for category: String) -> [TransactionVM] {
        if category == Constants.all {
            return getAllTransactions()
        }
        let results: [TransactionVM] = ModelData.sampleTransactions.compactMap({ model in
            if model.category.rawValue == category {
                let pinned = !unpinned.contains(model.id)
                return TransactionVM(model, isPinned: pinned)
            }
            return nil
        })
        return results
    }

    func getAllPinnedTransactions(for category: String) -> [TransactionVM] {
        let results: [TransactionVM] = ModelData.sampleTransactions.compactMap({ model in
            if model.category.rawValue == category {
                let pinned = !unpinned.contains(model.id)
                if pinned {
                    return TransactionVM(model)
                }
            }
            return nil
        })
        return results
    }
}

// MARK: - Support for Insights
extension AllTransactionsVM {

    struct GraphPoint {
        let category: String
        let offset: Double
        let ratio: Double
    }

    func calcGraphPoints() {
        let allTotal = calcAllTotals()
        var currAngle: Double = 0.0
        var data = [GraphPoint]()

        _ = TransactionModel.Category.allCases.map { category in
            let catTotal = calcTotal(for: category.rawValue)
            let angle = catTotal/allTotal
            let point = GraphPoint(category: category.rawValue, offset: currAngle, ratio: angle)
            data.append(point)
            currAngle += angle
        }
        graphPoints = data
    }
    
    func offset(for categoryIndex: Int) -> Double {
        if !graphPoints.isEmpty && categoryIndex < graphPoints.count {
            return graphPoints[categoryIndex].offset
        }
        return 0.0
    }
    
    func ratio(for categoryIndex: Int) -> Double {
        if !graphPoints.isEmpty && categoryIndex < graphPoints.count {
            return graphPoints[categoryIndex].ratio
        }
        return 0.0
    }
}

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
            calcTotalPriceForCategorySelected()
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
        calcTotalPriceForCategorySelected()
    }
}

// MARK: - Support for calculations
extension AllTransactionsVM {

    private func calcTotal(for category: String) -> Double {
        let txs = getAllPinnedTransactions(for: category)
        let t = txs.reduce(0, { $0 + $1.transaction.amount })
        return round(100*t)/100
    }
    
    // Verified in testTotalsByCategory, testUnpinnedTransactionsTotalByCategory
    func calcTotalForCategorySelected() -> Double {
        calcTotal(for: categorySelected)
    }
    
    private func calcTotalPriceForCategorySelected() {
         categoryTotal = calcTotalPriceForCategory(categorySelected)
    }
    
     func calcTotalPriceForCategory(_ category: String) -> String {
        let total = calcTotal(for: category)
        return "$\(total.formatted())"
    }
    
   // Verified in testUnpinnedTransactionsTotalByCategory
    func calcTotalAllCategories() -> Double {
        calcTotal(for: Constants.all)
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

    private func getAllPinnedTransactions() -> [TransactionVM] {
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
        if category == Constants.all {
            return getAllPinnedTransactions()
        }
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
        let allTotal = calcTotalAllCategories()
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

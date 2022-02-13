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

    typealias Category = TransactionModel.Category

    @Published var transactions: [TransactionModel] = []   //For category selected

    // Verified in testFilterTransactionsByCategory
    @Published var categorySelected = Category.all {
        didSet {
            transactions = categorySelected.getAllTransactions()
            calcTotalPriceForCategorySelected()
        }
    }
    
    @Published var categoryTotal: String = ""            // Used in TotalsView
    
    @Published var graphPoints = [GraphPoint]()          // Insights
    
    init() {
        categorySelected = Category.all
    }
    
    func pinTransaction() {
        calcTotalPriceForCategorySelected()
    }

    // For test purposes only: testUnpinnedTransactionsTotalByCategory
    func pinTransaction(id: Int, isPinned: Bool) {
        let trx = ModelData.sampleTransactions.first(where: { id == $0.id })
        trx?.isPinned = isPinned
    }
}

// MARK: - Support for calculations
extension AllTransactionsVM {

    private func calcTotal(for category: Category) -> Double {
        let txs = category.getAllPinnedTransactions()
        let t = txs.reduce(0, { $0 + $1.amount })
        return round(100*t)/100
    }
    
    // Verified in testTotalsByCategory, testUnpinnedTransactionsTotalByCategory
    func calcTotalForCategorySelected() -> Double {
        calcTotal(for: categorySelected)
    }
    
    private func calcTotalPriceForCategorySelected() {
         categoryTotal = calcTotalPriceForCategory(categorySelected)
    }
    
    func calcTotalPriceForCategory(_ category: Category) -> String {
        let total = calcTotal(for: category)
        return "$\(total.formatted())"
    }
    
   // Verified in testUnpinnedTransactionsTotalByCategory
    func calcTotalAllCategories() -> Double {
        calcTotal(for: Category.all)
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
            let catTotal = calcTotal(for: category)
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

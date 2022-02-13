//
//  TransactionModel.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import Foundation
import SwiftUI

// MARK: - TransactionModel

class TransactionModel: ObservableObject {
    
    @Published var isPinned: Bool

    init(id: Int, name: String, category: TransactionModel.Category, amount: Double, date: Date, accountName: String, provider: TransactionModel.Provider?, pinned: Bool = true) {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
        self.date = date
        self.accountName = accountName
        self.provider = provider
        self.isPinned = pinned
    }
    
    enum Category: String, CaseIterable {
        case all
        case food
        case health
        case entertainment
        case shopping
        case travel
    
        static let items: [Category] = [.food, .health, .entertainment, .shopping, .travel]
    }
    
    enum Provider: String {
        case amazon
        case americanAirlines
        case burgerKing
        case cvs
        case exxonmobil
        case jCrew
        case starbucks
        case timeWarner
        case traderJoes
        case uber
        case wawa
        case wendys
    }
    
    let id: Int
    let name: String
    let category: Category
    let amount: Double
    let date: Date
    let accountName: String
    let provider: Provider?
}

extension TransactionModel: Identifiable {}

// MARK: - Category

extension TransactionModel.Category: Identifiable {
    var id: String {
        rawValue
    }
    
    var background: Color {
        switch self {
        case .food:
            return .green
        case .health:
            return .red
        case .entertainment:
            return .orange
        case .shopping:
            return .blue
        case .travel:
            return .purple
        case .all:
            return .black
        }
    }
}

extension TransactionModel.Category {
    static subscript(index: Int) -> Self? {
        guard
            index >= 0 &&
            index < TransactionModel.Category.allCases.count
        else {
            return nil
        }
        
        return TransactionModel.Category.allCases[index]
    }
}

// MARK: - Support for getting transactions
extension TransactionModel.Category {
    
    func getAllTransactions() -> [TransactionModel] {
        if self == .all {
            return ModelData.sampleTransactions
        }
        return ModelData.sampleTransactions.filter {
            $0.category == self
        }
    }

    func getAllPinnedTransactions() -> [TransactionModel] {
        if self == .all {
            return ModelData.sampleTransactions.filter { $0.isPinned }
        }
        return ModelData.sampleTransactions.filter {
            $0.category == self && $0.isPinned
        }
    }
}

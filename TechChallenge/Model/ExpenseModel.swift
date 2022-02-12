//
//  ExpenseModel.swift
//  TechChallenge
//
//  Created by Felipe Gomez on 2/10/22.
//

import Foundation
import SwiftUI

// MARK: - ExpenseModel

struct ExpenseModel {
    static public var categories: [String] {
        var categories = TransactionModel.Category.allCases.map { $0.rawValue }
        categories.insert(Constants.all, at: 0)
        return categories
    }
    
    static public func backgroundColor(_ name: String) -> Color {
        TransactionModel.Category(rawValue: name)?.background ?? .black
    }
}

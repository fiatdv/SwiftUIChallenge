//
//  TransactionModel+UI.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 12/8/21.
//

import SwiftUI

extension TransactionModel {
    var image: Image {
        guard
            let provider = provider,
            let uiImage = UIImage(named: provider.rawValue)
        else {
            return Image(systemName: "questionmark.circle.fill")
        }
        
        return Image(uiImage: uiImage)
    }
}

extension TransactionModel.Category {
    var color: Color {
        switch self {
        case .food:
            return .green
        case .health:
            return .pink
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


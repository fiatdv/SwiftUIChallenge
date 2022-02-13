//
//  CategorySelectionView.swift
//  TechChallenge
//
//  Created by Felipe Gomez on 2/10/22.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var avm: AllTransactionsVM
    private var gridItems = [GridItem()]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: gridItems, spacing: 10) {
                ForEach(TransactionModel.Category.allCases, id: \.self) { category in
                    Button(category.rawValue) {
                        avm.categorySelected = category
                    }
                    .buttonStyle(DimmingButton(category: category))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 76)
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 18))
        }
        .background(Color.accentColor.opacity(0.8))
    }
}

struct ExpenseCategoriesGridView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectionView()
        .environmentObject(AllTransactionsVM())
    }
}


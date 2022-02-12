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
            LazyHGrid(rows: gridItems, spacing: 12) {
                ForEach(ExpenseModel.categories, id: \.self) { category in
                    Button(category) {
                        avm.categorySelected = category
                    }
                    .buttonStyle(DimmingButton(category: category))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
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


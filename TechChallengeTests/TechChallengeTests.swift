//
//  TechChallengeTests.swift
//  TechChallengeTests
//
//  Created by Adrian Tineo Cabello on 30/7/21.
//

import XCTest
@testable import TechChallenge

typealias Category = TransactionModel.Category

class TechChallengeTests: XCTestCase {
    var avm = AllTransactionsVM()
    
    // Test to ensure category selections is filtering transactions correctly
    func testFilterTransactionsByCategory() throws {

        avm.categorySelected = Constants.all        // Set Category
        XCTAssertEqual(avm.transactions.count, 13)  // Check Number of Transactions

        avm.categorySelected = Category.food.rawValue
        XCTAssertEqual(avm.transactions.count, 5)

        avm.categorySelected = Category.health.rawValue
        XCTAssertEqual(avm.transactions.count, 1)

        avm.categorySelected = Category.entertainment.rawValue
        XCTAssertEqual(avm.transactions.count, 1)
        
        avm.categorySelected = Category.shopping.rawValue
        XCTAssertEqual(avm.transactions.count, 3)

        avm.categorySelected = Category.travel.rawValue
        XCTAssertEqual(avm.transactions.count, 3)
    }

    // Test to ensure totals are correctly computed per category
    func testTotalsByCategory() throws {
        
        XCTAssertEqual(avm.calcAllTotals(), 472.08)

        avm.categorySelected = Category.food.rawValue
        XCTAssertEqual(avm.calcTotalCategory(), 74.28)

        avm.categorySelected = Category.health.rawValue
        XCTAssertEqual(avm.calcTotalCategory(), 21.53)

         avm.categorySelected = Category.entertainment.rawValue
        XCTAssertEqual(avm.calcTotalCategory(), 82.99)

        avm.categorySelected = Category.shopping.rawValue
        XCTAssertEqual(avm.calcTotalCategory(), 78.0)

        avm.categorySelected = Category.travel.rawValue
        XCTAssertEqual(avm.calcTotalCategory(), 215.28)
    }
    
    // Test to ensure totals are correctly computed per category with Unpinned
    func testUnpinnedTransactionsTotalByCategory() throws {

        avm.categorySelected = Category.food.rawValue
        avm.pinTransaction(id: 3, isPinned: false)
        XCTAssertEqual(avm.calcTotalCategory(), 48.96)

        avm.categorySelected = Category.health.rawValue
        avm.pinTransaction(id: 8, isPinned: false)
        XCTAssertEqual(avm.calcTotalCategory(), 0.00)

        avm.categorySelected = Category.entertainment.rawValue
        avm.pinTransaction(id: 1, isPinned: false)
        XCTAssertEqual(avm.calcTotalCategory(), 0.00)

        avm.categorySelected = Category.shopping.rawValue
        avm.pinTransaction(id: 2, isPinned: false)
        XCTAssertEqual(avm.calcTotalCategory(), 23.4)

        avm.categorySelected = Category.travel.rawValue
        avm.pinTransaction(id: 5, isPinned: false)
        XCTAssertEqual(avm.calcTotalCategory(), 161.0)
        
        XCTAssertEqual(avm.calcAllTotals() , 233.36)
    }
}

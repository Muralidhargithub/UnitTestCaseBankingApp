//
//  UnitTestCaseBankingAppTests.swift
//  UnitTestCaseBankingAppTests
//
//  Created by Muralidhar reddy Kakanuru on 11/26/24.
//

// Account.swift

// Account.swift

enum AccountError: Error {
    case negativeDeposit
    case negativeWithdrawal
    case insufficientFunds
}

class Account {
    private var balance: Double
    
    init(_ initialBalance: Double) {
        self.balance = initialBalance
    }
    
    func deposit(amount: Double) throws {
        guard amount > 0 else {
            throw AccountError.negativeDeposit
        }
        balance += amount
    }
    
    func withdraw(amount: Double) throws {
        guard amount > 0 else {
            throw AccountError.negativeWithdrawal
        }
        guard balance >= amount else {
            throw AccountError.insufficientFunds
        }
        balance -= amount
    }
    
    func getBalance() -> Double {
        return balance
    }
}




import XCTest
@testable import UnitTestCaseBankingApp

final class UnitTestCaseBankingAppTests: XCTestCase {
    var account: Account!

    override func setUpWithError() throws {
        account = Account(100.0)
    }

    override func tearDownWithError() throws {
        account = nil
    }
    func testNegativeInitialBalance() {
        XCTAssertThrowsError(try Account(-100.0)) { error in
            XCTAssertEqual(error as? AccountError, AccountError.negativeDeposit)
        }
    }

    func testDeposit() throws {
        try account.deposit(amount: 50.0)
        XCTAssertEqual(account.getBalance(), 150.0, "Balance should be 150.0 after depositing 50.0")

        try account.deposit(amount: 100.0)
        XCTAssertEqual(account.getBalance(), 250.0, "Balance should be 250.0 after depositing 100.0")

        XCTAssertThrowsError(try account.deposit(amount: 0)) { error in
            XCTAssertEqual(error as? AccountError, AccountError.negativeDeposit)
        }

        XCTAssertThrowsError(try account.deposit(amount: -10)) { error in
            XCTAssertEqual(error as? AccountError, AccountError.negativeDeposit)
        }
    }

    func testWithdraw() throws {
        try account.withdraw(amount: 40.0)
        XCTAssertEqual(account.getBalance(), 60.0, "Balance should be 60.0 after withdrawing 40.0")

        XCTAssertThrowsError(try account.withdraw(amount: 200.0)) { error in
            XCTAssertEqual(error as? AccountError, AccountError.insufficientFunds)
        }

        XCTAssertThrowsError(try account.withdraw(amount: -10.0)) { error in
            XCTAssertEqual(error as? AccountError, AccountError.negativeWithdrawal)
        }
    }

    func testGetBalance() {
        XCTAssertEqual(account.getBalance(), 100.0, "Initial balance should be 100.0")
    }
    func testWithdrawToZeroBalance() throws {
        try account.withdraw(amount: 100.0)
        XCTAssertEqual(account.getBalance(), 0.0, "Balance should be 0.0 after withdrawing the entire amount")
    }
    func testLargeDeposit() throws {
        let largeAmount = Double.greatestFiniteMagnitude / 2
        try account.deposit(amount: largeAmount)
        XCTAssertEqual(account.getBalance(), 100.0 + largeAmount, "Balance should correctly reflect large deposit")
    }
    func testMultipleTransactions() throws {
        try account.deposit(amount: 50.0)
        XCTAssertEqual(account.getBalance(), 150.0, "Balance should be 150.0 after first deposit")

        try account.withdraw(amount: 30.0)
        XCTAssertEqual(account.getBalance(), 120.0, "Balance should be 120.0 after withdrawal")

        try account.deposit(amount: 80.0)
        XCTAssertEqual(account.getBalance(), 200.0, "Balance should be 200.0 after second deposit")
    }
    
    func testSmallAmountTransactions() throws {
        try account.deposit(amount: 0.01)
        XCTAssertEqual(account.getBalance(), 100.01, "Balance should be 100.01 after depositing 0.01")

        try account.withdraw(amount: 0.01)
        XCTAssertEqual(account.getBalance(), 100.0, "Balance should return to 100.0 after withdrawing 0.01")
    }
    



}

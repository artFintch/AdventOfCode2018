//
//  Day1Tests.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day1Tests: XCTestCase {

    private let solution = TestSolution<Day1>(
        silverAnswer: 420,
        goldAnswer: 227
    )
    
    func testSilver() {
        measure {
            XCTAssert(solution.checkSilver())
        }
    }
    
    func testGold() {
        measure {
            XCTAssert(solution.checkGold())
        }
    }
}

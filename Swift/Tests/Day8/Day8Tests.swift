//
//  Day8Tests.swift
//  Day8Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day8Tests: XCTestCase {
    
    private let solution = TestSolution<Day8>(
        silverAnswer: 42768,
        goldAnswer: 34348
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

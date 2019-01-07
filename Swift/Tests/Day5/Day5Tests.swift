//
//  Day5Tests.swift
//  Day5Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day5Tests: XCTestCase {
    
    private let solution = TestSolution<Day5>(
        silverAnswer: 10638,
        goldAnswer: 4944
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

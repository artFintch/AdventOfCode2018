//
//  Day11Tests.swift
//  Day11Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day11Tests: XCTestCase {
    
    private let solution = TestSolution<Day11>(
        silverAnswer: "21,22",
        goldAnswer: "235,288,13"
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

//
//  Day10Tests.swift
//  Day10Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day10Tests: XCTestCase {
    
    private let solution = TestSolution<Day10>(
        silverAnswer: Manual(),
        goldAnswer: 10036
    )
    
    func testGold() {
        measure {
            XCTAssert(solution.checkGold())
        }
    }
}

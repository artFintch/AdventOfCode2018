//
//  Day20Tests.swift
//  Day20Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day20Tests: XCTestCase {
    
    private let solution = TestSolution<Day20>(
        silverAnswer: 3755,
        goldAnswer: 8627
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

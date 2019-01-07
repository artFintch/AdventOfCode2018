//
//  Day18Tests.swift
//  Day18Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day18Tests: XCTestCase {
    
    private let solution = TestSolution<Day18>(
        silverAnswer: 583426,
        goldAnswer: 169024
    )
    
    func testSilver() {
        measure {
            XCTAssert(solution.checkSilver())
        }
    }
    
    func testGold() {
        XCTAssert(solution.checkGold())
        measure {
            // Need optimisations
            // XCTAssert(solution.checkGold())
        }
    }
}

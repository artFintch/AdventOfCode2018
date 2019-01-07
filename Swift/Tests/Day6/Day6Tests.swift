//
//  Day6Tests.swift
//  Day6Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day6Tests: XCTestCase {
    
    private let solution = TestSolution<Day6>(
        silverAnswer: 3871,
        goldAnswer: 44667
    )
    
    func testSilver() {
        XCTAssert(solution.checkSilver())
        measure {
            // Need optimisations
            // XCTAssert(solution.checkSilver())
        }
    }
    
    func testGold() {
        measure {
            XCTAssert(solution.checkGold())
        }
    }
}

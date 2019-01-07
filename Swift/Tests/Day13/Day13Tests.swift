//
//  Day13Tests.swift
//  Day13Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day13Tests: XCTestCase {
    
    private let solution = TestSolution<Day13>(
        silverAnswer: Point(83, 49),
        goldAnswer: Point(73, 36)
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

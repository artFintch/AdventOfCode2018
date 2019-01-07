//
//  Day22Tests.swift
//  Day22Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day22Tests: XCTestCase {
    
    private let solution = TestSolution<Day22>(
        silverAnswer: 8735,
        goldAnswer: 984
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

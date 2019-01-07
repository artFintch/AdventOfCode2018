//
//  Day2Tests.swift
//  Day2Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day2Tests: XCTestCase {
    
    private let solution = TestSolution<Day2>(
        silverAnswer: 6723,
        goldAnswer: "prtkqyluiusocwvaezjmhmfgx"
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

//
//  Day16Tests.swift
//  Day16Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day16Tests: XCTestCase {
    
    private let solution = TestSolution<Day16>(
        silverAnswer: 560,
        goldAnswer: 622
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

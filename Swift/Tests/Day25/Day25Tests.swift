//
//  Day25Tests.swift
//  Day25Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day25Tests: XCTestCase {
    
    private let solution = TestSolution<Day25>(
        silverAnswer: 386,
        goldAnswer: Manual()
    )
    
    func testSilver() {
        measure {
            XCTAssert(solution.checkSilver())
        }
    }
}

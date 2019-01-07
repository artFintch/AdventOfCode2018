//
//  Day7Tests.swift
//  Day7Tests
//
//  Created by Vyacheslav Khorkov on 07/01/2019.
//  Copyright © 2019 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day7Tests: XCTestCase {
    
    private let solution = TestSolution<Day7>(
        silverAnswer: "OVXCKZBDEHINPFSTJLUYRWGAMQ",
        goldAnswer: 955
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

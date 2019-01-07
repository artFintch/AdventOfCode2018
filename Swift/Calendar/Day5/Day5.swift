//
//  main.swift
//  Day5
//
//  Created by Vyacheslav Khorkov on 05/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Day5: Solution {
    func readInput(from path: String) -> [UInt32] {
        return Frog(path).readLine()!.map { $0.unicodeScalars.first!.value }
    }
    
    func silver(_ input: [UInt32]) -> Int {
        return input.collaps(by: { $0 != $1 && $0.caseInsensitiveEqual($1) }).count
    }
    
    func gold(_ input: [UInt32]) -> Int {
        let input = input.collaps(by: { $0 != $1 && $0.caseInsensitiveEqual($1) })
        var min = input.count
        for scalar: UInt32 in 65..<97 {
            min = Swift.min(min, input.collaps(by: { $0 != $1 && $0.caseInsensitiveEqual($1) },
                                               skip: { $0.caseInsensitiveEqual(scalar) },
                                               stop: { $0.count > min }).count)
        }
        return min
    }
}

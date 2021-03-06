//
//  main.swift
//  Day2
//
//  Created by Vyacheslav Khorkov on 02/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

struct Day2: Solution {
    func readInput(from path: String) -> [String] {
        return Frog(path).readLines()
    }
    
    func silver(_ input: [String]) -> Int {
        var (twice, threeTimes) = (0, 0)
        for line in input {
            let map = Dictionary(grouping: line, by: { $0 })
            let set = Set(map.values.map { $0.count })
            if set.contains(3) { threeTimes += 1 }
            if set.contains(2) { twice += 1 }
        }
        return twice * threeTimes
    }
    
    func gold(_ input: [String]) -> String? {
        for (lhs, rhs) in input.makeCombinationsIterator() {
            if lhs.diff(rhs, max: 1) {
                return zip(lhs, rhs).lazy
                    .filter(==)
                    .map { (lhs, rhs) in String(lhs) }
                    .reduce("", +)
            }
        }
        return nil
    }
}

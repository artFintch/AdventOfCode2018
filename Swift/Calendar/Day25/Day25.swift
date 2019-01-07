//
//  main.swift
//  Day25
//
//  Created by Vyacheslav Khorkov on 25/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

//func silver() -> Int {
//    let lines = Frog("input.txt")!.readLines()
//    let matrix = lines.map { $0.components(separatedBy: ",") }
//    var set = Set(matrix.map { $0.compactMap(Int.init) })
//    var groups = 0
//    while let current = set.first {
//        search(current, &set)
//        groups += 1
//    }
//    return groups
//}
//measure(silver() == 386) // 48 ms

struct Day25: Solution {
    func readInput(from path: String) -> [String] {
        return Frog(path).readLines()
    }
    
    func silver(_ lines: [String]) -> Int {
        let matrix = lines.map { $0.components(separatedBy: ",") }
        var set = Set(matrix.map { $0.compactMap(Int.init) })
        var groups = 0
        while let current = set.first {
            search(current, &set)
            groups += 1
        }
        return groups
    }
    
    func gold(_ lines: [String]) -> Manual {
        return Manual()
    }
    
    private func distance(_ lhs: [Int], _ rhs: [Int]) -> Int {
        return lhs.indices.reduce(0) { $0 + Swift.abs(lhs[$1] - rhs[$1]) }
    }
    
    private func search(_ begin: [Int], _ set: inout Set<[Int]>) {
        set.remove(begin)
        for current in set {
            if distance(begin, current) <= 3 {
                search(current, &set)
            }
        }
    }
}

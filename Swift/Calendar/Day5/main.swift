//
//  main.swift
//  Day5
//
//  Created by Vyacheslav Khorkov on 05/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

let input = Array(Frog("input.txt")!.readLine()!).map(String.init)

// Utils
extension Array where Element == String {
    func collaps(by pattern: (Element, Element) -> Bool,
                 skip: (Element) -> Bool = { _ in false }) -> Array {
        var p: [String] = []
        for s in self {
            if skip(s) { continue }
            else if p.isEmpty { p.append(s) }
            else if pattern(s, p.last!) { p.removeLast() }
            else { p.append(s) }
        }
        return p
    }
}

let pattern: (String, String) -> Bool = { $0 != $1 && $0.uppercased() == $1.uppercased() }
print(input.collaps(by: pattern).count) // Part1

let min = "abcdefghijklmnopqrstuvwxyz".map { String($0) }.lazy
    .map { s in input.collaps(by: pattern, skip: { $0.lowercased() == s }).count }
    .min()!
print(min) // Part2

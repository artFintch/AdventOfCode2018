//
//  main.swift
//  Day1
//
//  Created by Vyacheslav Khorkov on 01/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

// Input
func readInput() -> [String] {
    let frog = Frog("input.txt")
    var lines: [String] = []
    while let line = frog?.readLine() {
        lines.append(line)
    }
    return lines
}
var lines = readInput()

// Part1
var twice = 0, threeTimes = 0
for line in lines {
    let map = Dictionary(grouping: line, by: { $0 })
    let uniq = Set(map.values.map { $0.count })
    if uniq.contains(3) { threeTimes += 1 }
    if uniq.contains(2) { twice += 1 }
}
print(twice * threeTimes)

// Part2
search: for lineBox in lines.enumerated() {
    for line in lines.dropFirst(lineBox.offset) {
        let compare = zip(lineBox.element, line).filter(==)
        if line.count == compare.count + 1 {
            print(compare.reduce("") { $0 + String($1.0) })
            break search
        }
    }
}

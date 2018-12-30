//
//  main.swift
//  Day2
//
//  Created by Vyacheslav Khorkov on 02/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

var lines = Frog("input.txt")!.readLines()

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

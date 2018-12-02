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
var numbers = readInput().compactMap(Int.init)

// Part1
print(numbers.reduce(0, +))

// Part2
var sum = 0, i = 0
var set = Set([sum])
while true {
    sum += numbers[i % numbers.count]
    i += 1
    if !set.insert(sum).inserted {
        print(sum)
        break
    }
}

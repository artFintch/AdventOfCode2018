//
//  main.swift
//  Day1
//
//  Created by Vyacheslav Khorkov on 01/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

extension Frog {
    func readFrequencies() -> [Int] {
        return readLines().compactMap(Int.init)
    }
}

func silver(_ input: [Int]) -> Int {
    return input.reduce(0, +)
}

func gold(_ input: [Int]) -> Int {
    var (frequency, step) = (0, 0)
    var seen: Set<Int> = []
    while seen.insert(frequency).inserted {
        frequency += input[step % input.count]
        step += 1
    }
    return frequency
}

let numbers = Frog().readFrequencies()
measure(silver(numbers) == 420) // ~1 ms
measure(gold(numbers) == 227)   // ~19 ms

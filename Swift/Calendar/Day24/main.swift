//
//  main.swift
//  Day24
//
//  Created by Vyacheslav Khorkov on 24/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

func readInput() -> [Group] {
    let armies = Frog("input.txt")!.readLines().split(separator: "")
    return parse(armies[0], false) + parse(armies[1], true)
}

func silver() -> Int? {
    return fight(readInput())
}

func gold(_ boost: Int) -> Int? {
    return fight(readInput(), boost: boost)
}

measure(silver() == 16006) // 40 ms
measure(binarySearch(1..<50, gold).result == 6221) // 270 ms

//
//  main.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 04/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

// Utils
extension DateFormatter {
    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

// Input
let parser = DateFormatter("yyyy-MM-dd HH:mm")
let lines = Frog("input.txt")!.readLines().lazy
    .map { $0.components(separatedBy: ["[", "]", " ", "#"]).filter { !$0.isEmpty } }
    .map { (parser.date(from: "\($0[0]) \($0[1])")!, $0[2].hasPrefix("f"), Int($0[3])) }
    .sorted { $0.0 < $1.0 }
    .map { (Calendar.current.component(.minute, from: $0.0), $0.1, $0.2) }

var begin = -1, id = -1
var schedule: [Int: [Int: Int]] = [:]
for line in lines {
    if line.2 != nil { id = line.2! }
    else if line.1 { begin = line.0 }
    else { (begin..<line.0).forEach { schedule[id, default: [:]][$0, default: 0] += 1 } }
}

let gid = schedule.lazy
    .map { ($0.key, $0.value.values.reduce(0, +)) }
    .max { $0.1 < $1.1 }
    .map { $0.0 }!
let frqm = schedule[gid]!.lazy
    .max { $0.1 < $1.1 }
    .map { $0.0 }!
print(frqm * gid) // Part 1

let maxGuard = schedule.max { $0.value.values.max()! < $1.value.values.max()! }!
let sameMin = maxGuard.1.max { $0.1 < $1.1 }!.0
print(maxGuard.0 * sameMin) // Part 2

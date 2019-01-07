//
//  main.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 04/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog
import AdventCode

extension Dictionary where Key == Int, Value == Int {
    func sum() -> Int {
        return values.reduce(0, +)
    }
    
    func max() -> Int? {
        return values.max()
    }
}

struct Day4: Solution {
    func readInput(from path: String) -> [GuardRecord] {
        var records: [GuardRecord] = []
        let parser = DateFormatter("yyyy-MM-dd HH:mm")
        for line in Frog(path).readLines() {
            let parts = line
                .components(separatedBy: ["[", "]", " ", "#"])
                .filter { !$0.isEmpty }
            
            let id = Int(parts[3])
            let fallsAsleep = parts[2].hasPrefix("falls")
            let date = parser.date(from: "\(parts[0]) \(parts[1])")!
            let record = GuardRecord(id: id, fallsAsleep: fallsAsleep, date: date)
            records.append(record)
        }
        records.sort { lhs, rhs in lhs.date < rhs.date }
        return records
    }
    
    func silver(_ records: [GuardRecord]) -> Int {
        let schedule = Schedule(records)
        let id = schedule.lazy
            .max { lhs, rhs in lhs.value.sum() < rhs.value.sum() }
            .map { id, _ in id }!
        let minutes = schedule[id]!.lazy
            .max { lhs, rhs in lhs.value < rhs.value }
            .map { id, _ in id }!
        return minutes * id
    }
    
    func gold(_ records: [GuardRecord]) -> Int {
        let schedule = Schedule(records)
        let maxGuard = schedule.max { lhs, rhs in lhs.value.max()! < rhs.value.max()! }!
        let sameMin = maxGuard.value.max { lhs, rhs in lhs.value < rhs.value }!
        return maxGuard.key * sameMin.key
    }
}

//let records = Frog().readGuardRecords()
//measure(silver(records) == 138280) // 3 ms
//measure(gold(records) == 89347)    // 3 ms

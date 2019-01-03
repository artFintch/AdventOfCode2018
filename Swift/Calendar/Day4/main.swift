//
//  main.swift
//  Day4
//
//  Created by Vyacheslav Khorkov on 04/12/2018.
//  Copyright © 2018 Vyacheslav Khorkov. All rights reserved.
//

import Frog

extension Dictionary where Key == Int, Value == Int {
    func sum() -> Int {
        return values.reduce(0, +)
    }
    
    func max() -> Int? {
        return values.max()
    }
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

let records = Frog().readGuardRecords()
measure(silver(records) == 138280) // 3 ms
measure(gold(records) == 89347)    // 3 ms
